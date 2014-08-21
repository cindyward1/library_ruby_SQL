require "spec_helper"

describe Patron do

  it "is initialized with a name and a phone number" do
    test_patron = Patron.new({:name=>"Cindy Ward", :id=>1, :phone_number=>"503-555-1212"})
    expect(test_patron).to be_an_instance_of Patron
    expect(test_patron.id).to eq 1
    expect(test_patron.name).to eq "Cindy Ward"
    expect(test_patron.phone_number).to eq "503-555-1212"
  end

  it "is saved to the database" do
  	test_patron = Patron.new({:name=>"Cindy Ward", :id=>1, :phone_number=>"503-555-1212"})
    test_patron.save
    expect(Patron.all).to eq [test_patron]
  end

  it "is retrieved from the database by id, by name or by phone number" do
    test_patron = Patron.new({:name=>"Cindy Ward", :id=>1, :phone_number=>"503-555-1212"})
    test_patron.save
    test_patron1 = Patron.get_by_id(test_patron.id).first
    expect(test_patron).to eq test_patron1
    test_patron2 = Patron.get_by_name("Cindy Ward").first
    expect(test_patron).to eq test_patron2
    test_patron3 = Patron.get_by_phone_number("503-555-1212").first
    expect(test_patron).to eq test_patron3
  end

	it "is updated with a new name and/or a new phone number" do
    test_patron = Patron.new({:name=>"Cynthia Jean Ward", :id=>1, :phone_number=>"555-555-1212"})
    test_patron.save
    test_patron1 = Patron.get_by_name("Cynthia Jean Ward").first
    test_patron1.update_name("Cindy Ward")
    expect(Patron.get_by_name("Cynthia Jean Ward")).to eq []
    test_patron2 = Patron.get_by_phone_number("555-555-1212").first
    test_patron2.update_phone_number("503-555-1212")
    expect(Patron.get_by_phone_number("555-555-1212")).to eq []
  end

  it "is deleted from the database" do
    test_patron = Patron.new({:name=>"Cindy Ward", :id=>1, :phone_number=>"503-555-1212"})
    test_patron.save
    test_patron.delete
    expect(Patron.all).to eq []
  end

  it "counts checkouts" do
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
    expect(test_patron.count_checkouts.first).to eq 1
  end

  it "counts overdue books" do
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
    expect(test_patron.count_overdue("09/30/2014").first).to eq 1
  end

end
