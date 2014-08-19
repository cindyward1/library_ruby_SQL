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

  it "is updated with a new title or a new 10-digit ISBN number" do
    test_book = Book.new({:title=>"The Iceman Came", :isbn_10=>"0300117443", :id=>1})
    test_book.save
    test_book1 = Book.get_by_title("The Iceman Came").first
    test_book1.update_title("The Iceman Cometh")
    expect(Book.get_by_title("The Iceman Came")).to eq []
    test_book2 = Book.get_by_isbn_10("0300117443").first
    test_book.update_isbn_10("0300117434")
    expect(Book.get_by_isbn_10("0300117443")).to eq []
  end

  it "is deleted from the database" do
    test_book = Book.new({:title=>"The Iceman Came", :isbn_10=>"0300117443", :id=>1})
    test_book.save
    test_book.delete
    expect(Book.all).to eq []
  end

  it "can count the number of copies of a book" do
  	test_book = Book.new({:title=>"Book Title 1", :isbn_10=>"0000000001", :id=>1})
  	test_book.save
  	test_copy1 = Copy.new({:book_id=>test_book.id, :checkout_id=>0})
  	test_copy1.save
  	test_copy2 = Copy.new({:book_id=>test_book.id, :checkout_id=>0})
  	test_copy2.save  	
  	test_copy3 = Copy.new({:book_id=>test_book.id, :checkout_id=>0})
  	test_copy3.save  	
  	test_copy4 = Copy.new({:book_id=>test_book.id, :checkout_id=>0})
  	test_copy4.save  	
  	test_copy5 = Copy.new({:book_id=>test_book.id, :checkout_id=>0})
  	test_copy5.save
  	expect(test_book.count_copies).to eq 5
  end

  it "can find all of the authors of a book" do
  	test_book = Book.new({:title=>"Book Title 1", :isbn_10=>"0000000001", :id=>1})
  	test_book.save
  	test_author1 = Author.new({:name=>"Grumpy"})
  	test_author1.save
  	test_written_by1 = Written_by.new({:book_id=>test_book.id, :author_id=>test_author1.id})
  	test_written_by1.save
  	test_author2 = Author.new({:name=>"Sleepy"})
  	test_author2.save
  	test_written_by2 = Written_by.new({:book_id=>test_book.id, :author_id=>test_author2.id})
  	test_written_by2.save
  	author_array = test_book.find_authors
  	expect(author_array.length).to eq 2
  	expect(author_array).to eq [test_author1, test_author2]
  end

  it "can find the copy and checkout ids from its ID and the patron's ID" do
    test_patron = Patron.new({:name=>"Cindy Ward", :phone_number=>'503-555-1212'})
    test_patron.save
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434"})
    test_book.save
    test_copy = Copy.new({:book_id=>test_book.id, :checkout_id=>0})
    test_copy.save
    test_checkout = Checkout.new(:patron_id=>test_patron.id, :copy_id=>test_copy.id)
    test_checkout.save
    test_copy.check_out(test_checkout.id)
    test_hash_array = test_book.find_copy_checkout_from_patron_book(test_patron.id)
    test_hash = test_hash_array.first
    expect(test_hash['copy_id']).to eq test_copy.id
    expect(test_hash['checkout_id']).to eq test_checkout.id
  end

end
