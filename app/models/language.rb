class Language
  include Mongoid::Document
  include Mongoid::Slugify

  field :name, type: String
  field :description, type: String
  field :glossary, type: Hash
  field :dictionary_file, type: String, default: File.join(Rails.root, 'words', 'dict.txt')
  has_many :corpora

  def histogram
    @histogram ||= corpora.map(&:histogram).inject(Hash.new(0)){ |m,k,v| m[k] += v }
  end

  ##
  # select a character based on a random value compared with the
  # character probability factorposition
  #
  # for example, assuming a structure of
  # a: 22
  # d: 5
  # e: 45
  # ..etc
  #
  # c = new Charlist
  # ... create structure as above ...
  # c.choice(25)
  # > 'd'
  #
  def choice(selection = rand(@total))
    position = 0
    @chars.each_with_index do |index, count|
      position += count
      if position >= selection
        return index
      end
    end
    false
  end

  def make_word
    char = ''
    key = ['^']
    word = ''
    while char != '$'
      char =
        word += char if char.is_a?(String)
    end
    word
  end

  def make_glossary
    gloss = { }
    File.open(dictionary_file, 'r') do |f|
      f.each do |word|
        gloss[word] = make_word
      end
    end
    update_attribute(glossary, gloss)
  end

  private
   def generate_slug
     name || id
   end

end
