require "spec_helper"

describe Copy do

  it "is initialized with a book but no checkout" do
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    test_copy = Copy.new({:id=>1, :book_id=>test_book.id, :checkout_id=>0})
    expect(test_copy).to be_an_instance_of Copy
    expect(test_copy.id).to eq 1
    expect(test_copy.book_id).to eq test_book.id
    expect(test_copy.checkout_id).to eq 0
  end

  it "is saved to the database" do
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    test_copy = Copy.new({:id=>1, :book_id=>test_book.id, :checkout_id=>0})
    test_copy.save
    expect(Copy.all).to eq [test_copy]
  end

	it "is retrieved from the database by book id if it not checked out" do
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    test_copy = Copy.new({:id=>1, :book_id=>test_book.id, :checkout_id=>0})
    test_copy.save
    test_copy1 = Copy.get_by_book_id_not_checked_out(test_book.id).first
    expect(test_copy).to eq test_copy1
  end

	it "is retrieved from the database by checkout_id" do
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    test_copy = Copy.new({:id=>1, :book_id=>test_book.id, :checkout_id=>5})
    test_copy.save
    test_copy1 = Copy.get_by_checkout_id(5).first
    expect(test_copy).to eq test_copy1
  end
end
