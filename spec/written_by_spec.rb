require "spec_helper"

describe Written_by do

  it "is initialized with an author id and a book id" do
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    test_author = Author.new({:name=>"Eugene ONeill", :id=>1})
    test_author.save
    test_written_by = Written_by.new({:id=>1, :author_id=>test_author.id, :book_id=>test_book.id})
    expect(test_written_by.author_id).to eq test_author.id
    expect(test_written_by.book_id).to eq test_book.id
  end

  it "is saved to the database" do
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    test_author = Author.new({:name=>"Eugene ONeill", :id=>1})
    test_author.save
    test_written_by = Written_by.new({:author_id=>test_author.id, :book_id=>test_book.id})
    test_written_by.save
    expect(Written_by.all).to eq [test_written_by]
  end

  it "is retrieved from the database by author id, book_id, or both author and book ids" do
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    test_author = Author.new({:name=>"Eugene ONeill", :id=>1})
    test_author.save
    test_written_by = Written_by.new({:author_id=>test_author.id, :book_id=>test_book.id})
    test_written_by.save
    test_written_by1 = Written_by.get_by_author_id(test_author.id).first
    expect(test_written_by).to eq test_written_by1
    test_written_by2 = Written_by.get_by_book_id(test_book.id).first
    expect(test_written_by).to eq test_written_by2
    test_written_by3 = Written_by.get_by_book_and_author_ids(test_book.id, test_author.id).first
    expect(test_written_by).to eq test_written_by3
  end

it "is deleted from the database" do
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    test_author = Author.new({:name=>"Eugene ONeill", :id=>1})
    test_author.save
    test_written_by = Written_by.new({:id=>1, :author_id=>test_author.id, :book_id=>test_book.id})
    test_written_by.save
    test_written_by.delete
    expect(Written_by.all).to eq []
  end

end
