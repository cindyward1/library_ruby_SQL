require "spec_helper"

describe Author do

  it "is initialized with a name" do
    test_author = Author.new({:name=>"Eugene ONeill", :id=>1})
    expect(test_author).to be_an_instance_of Author
    expect(test_author.id).to eq 1
    expect(test_author.name).to eq "Eugene ONeill"
  end

  it "is saved to the database" do
    test_author = Author.new({:name=>"Eugene ONeill", :id=>1})
    test_author.save
    expect(Author.all).to eq [test_author]
  end

  it "is retrieved from the database" do
    test_author = Author.new({:name=>"Eugene ONeill", :id=>1})
    test_author.save
    test_author1 = Author.get_by_name("Eugene ONeill").first
    expect(test_author).to eq test_author1
    test_author2 = Author.get_by_id(test_author.id).first
    expect(test_author).to eq test_author2
  end

   it "is updated with a new name" do
    test_author = Author.new({:name=>"Gene ONeill", :id=>1})
    test_author.save
    test_author1 = Author.get_by_name("Gene ONeill").first
    test_author1.update_name("Eugene ONeill")
    expect(Author.get_by_name("Gene ONeill")).to eq []
  end

  it "is deleted from the database" do
    test_author = Author.new({:name=>"Eugene ONeill", :id=>1})
    test_author.save
    test_author.delete
    expect(Author.all).to eq []
  end

 end
