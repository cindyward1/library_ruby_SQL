require "spec_helper"

describe Patron do

  it "is initialized with a name and a phone number" do
    test_patron = Patron.new({:name=>"Cindy Ward", :id=>1, :phone_number=>"503-555-1212"})
    expect(test_patron).to be_an_instance_of Patron
    expect(test_patron.id).to eq 1
    expect(test_patron.name).to eq "Cindy Ward"
  end

end
