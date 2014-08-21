require "spec_helper"

describe Checkout do

  it "is initialized with a patron, a copy, a checkout date, a due date, and a checkin date of '00/00/0000'" do
    test_patron = Patron.new({:name=>"Cindy Ward", :id=>1, :phone_number=>"503-555-1212"})
    test_patron.save
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    test_copy = Copy.new({:book_id=>test_book.id, :checkout_id=>0})
    test_copy.save
    test_checkout = Checkout.new({:id=>1, :patron_id=>test_patron.id, :copy_id=>test_copy.id,
                                  :checkout_date=>"08/16/2014", :due_date=>"09/15/2014"})
    expect(test_checkout).to be_an_instance_of Checkout
    expect(test_checkout.id).to eq 1
    expect(test_checkout.patron_id).to eq test_patron.id
    expect(test_checkout.copy_id).to eq test_copy.id
    expect(test_checkout.checkout_date).to eq "08/16/2014"
    expect(test_checkout.due_date).to eq "09/15/2014"
  end

  it "is saved to the database" do
    test_patron = Patron.new({:name=>"Cindy Ward", :id=>1, :phone_number=>"503-555-1212"})
    test_patron.save
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    test_copy = Copy.new({:book_id=>test_book.id, :checkout_id=>0})
    test_copy.save
    test_checkout = Checkout.new({:id=>1, :patron_id=>test_patron.id, :copy_id=>test_copy.id,
                                  :checkout_date=>"08/16/2014", :due_date=>"09/15/2014",
                                  :checkin_date=>"00/00/0000"})
    test_checkout.save
    expect(Checkout.all).to eq [test_checkout]
  end

  it "is retrieved from the database by its ID, its patron ID or its copy ID" do
    test_patron = Patron.new({:name=>"Cindy Ward", :id=>1, :phone_number=>"503-555-1212"})
    test_patron.save
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    test_copy = Copy.new({:book_id=>test_book.id, :checkout_id=>0})
    test_copy.save
    test_checkout = Checkout.new({:id=>1, :patron_id=>test_patron.id, :copy_id=>test_copy.id,
                                  :checkout_date=>"08/16/2014", :due_date=>"09/15/2014",
                                  :checkin_date=>"00/00/0000"})
    test_checkout.save
    test_checkout1 = Checkout.get_by_id(test_checkout.id)
    expect(test_checkout).to eq test_checkout1.first
    test_checkout2 = Checkout.get_by_patron_id(test_patron.id)
    expect(test_checkout).to eq test_checkout2.first
    test_checkout3 = Checkout.get_by_copy_id(test_copy.id)
    expect(test_checkout).to eq test_checkout3.first
  end

  it "is deleted from the database" do
    test_patron = Patron.new({:name=>"Cindy Ward", :id=>1, :phone_number=>"503-555-1212"})
    test_patron.save
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    test_copy = Copy.new({:book_id=>test_book.id, :checkout_id=>0})
    test_copy.save
    test_checkout = Checkout.new({:id=>1, :patron_id=>test_patron.id, :copy_id=>test_copy.id,
                                  :checkout_date=>"08/16/2014", :due_date=>"09/15/2014",
                                  :checkin_date=>"00/00/0000"})
    test_checkout.save
    test_checkout.delete
    expect(Checkout.all).to eq []
  end

  it "retrieves all checkouts that are overdue" do
    test_patron = Patron.new({:name=>"Cindy Ward", :id=>1, :phone_number=>"503-555-1212"})
    test_patron.save
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    test_copy = Copy.new({:book_id=>test_book.id, :checkout_id=>0})
    test_copy.save
    test_checkout = Checkout.new({:id=>1, :patron_id=>test_patron.id, :copy_id=>test_copy.id,
                                  :checkout_date=>"08/16/2014", :due_date=>"09/15/2014",
                                  :checkin_date=>"00/00/0000"})
    test_checkout.save
    test_checkout1 = Checkout.get_overdue("09/01/2014")
    expect(test_checkout1).to eq []
    test_checkout2 = Checkout.get_overdue("09/30/2014")
    expect(test_checkout2.first).to eq test_checkout
  end

  it "checks in a book by updating its checkin date to a date" do
    test_patron = Patron.new({:name=>"Cindy Ward", :id=>1, :phone_number=>"503-555-1212"})
    test_patron.save
    test_book = Book.new({:title=>"The Iceman Cometh", :isbn_10=>"0300117434", :id=>1})
    test_book.save
    test_copy = Copy.new({:book_id=>test_book.id, :checkout_id=>0})
    test_copy.save
    test_checkout = Checkout.new({:id=>1, :patron_id=>test_patron.id, :copy_id=>test_copy.id,
                                  :checkout_date=>"08/16/2014", :due_date=>"09/15/2014",
                                  :checkin_date=>"00/00/0000"})
    test_checkout.save
    test_checkout.check_in("08/19/2014")
    test_checkout1 = Checkout.get_by_id(test_checkout.id)
    expect(test_checkout1.first.checkin_date).to eq "08/19/2014"
  end

end
