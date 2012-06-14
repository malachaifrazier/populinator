class Chromosome
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  @@expressions = YAML::load(File.read(File.join(Rails.root, 'genetics', 'people.yml')))
  embedded_in :being
  embeds_many :genes

  def length 
    genes.length
  end

  def <=>(other)
    other.genes.map{ |g| g.value }.sum <=> genes.map{ |g| g.value }.sum
  end
  
  def to_s
    genes.join(' ')
  end
  
  # creates a random set of genes
  def randomize!(genecount = 10)
    genecount.times.each { genes << Gene.new(:code => Chromosome.rand_hex ) }
    self
  end

  def self.expressions 
    @@expressions
  end
  
  # walks through the genes and checks the genes against the
  # expression table, resulting in a hash of expressed genes.
  # for example: 
  #
  # {:hair=>{:blond=>2, :red=>1, :pink=>1, :plaid=>0}}
  #
  # This is meant to be consumed by a description engine of some kind.
  #
  def express(exps = Chromosome.expressions, set = genes.map{ |g| g.code }.join )
    result = { }
    exps.each_pair do |category, value|
      if value.is_a? Hash 
        result[category] = self.express(value, set)
      elsif value.is_a? Array
        matches = 0
        position = 0 
        value.each do |expression|
          while position
            position = set.index(expression, position + 1)
            matches += 1 if position
          end
        end
        result[category] ||= 0
        result[category] += matches
      end
    end
    result
  end
  
  #
  # gene at the supplied index value
  #
  def [](index)
    genes[index].code
  end

  #
  # append a gene
  #
  def <<(gene)
    genes << gene 
  end

  
  #
  # set the gene at the supplied index value
  #
  def []=(index, value)
    genes[index].code = value if value.is_a? String and value.length == 7
  end
  
  def reproduce_with(other)
    c = Chromosome.new
    self.genes.length.times do |i|
      c.genes << ((rand > 0.5) ? self.genes[i] : other.genes[i])
    end
    c
  end

  def mutate 
    index = (rand * length).floor
    genes[index] = Chromosome.rand_hex
  end
  
  # generates a 6 digit hex number as a string
  def self.rand_hex
    ("%06x" % (rand * 16777215).floor).upcase
  end

  def walk 
    genes.each do |gene|
      yield gene
    end
  end

  
end


