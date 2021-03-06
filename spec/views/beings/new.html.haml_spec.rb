require 'spec_helper'

describe "beings/new" do
  before(:each) do
    assign(:being, stub_model(Being,
      :name => "MyString",
      :gender => "MyString",
      :age => ""
    ).as_new_record)
  end

  it "renders new being form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => beings_path, :method => "post" do
      assert_select "ul.form"
      #assert_select "input#_gender"
      #assert_select "input#_age"
    end
  end
end
