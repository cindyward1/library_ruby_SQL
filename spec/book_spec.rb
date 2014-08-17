require "spec_helper"

describe Book do

  it "is initialized with a title and a 10-digit ISBN" do
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    expect(test_book).to be_an_instance_of Book
    expect(test_book.id).to eq 1
    expect(test_book.title).to eq "The Iceman Cometh"
    expect(test_book.isbn_10).to eq "0300117434"
  end

  it "is saved to the database" do
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    expect(Book.all).to eq [test_book]
  end

  it "is retrieved from the database" do
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    test_book1 = Book.get_by_title("The Iceman Cometh").first
    expect(test_book).to eq test_book1
    test_book2 = Book.get_by_id(test_book.id).first
    expect(test_book).to eq test_book2
  end

end
