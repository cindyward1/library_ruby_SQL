require "spec_helper"

describe Checkout do

  it "is initialized with a patron, a copy, a checkout date, and a due date" do
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

end
