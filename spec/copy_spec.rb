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

end
