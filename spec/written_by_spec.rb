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

end
