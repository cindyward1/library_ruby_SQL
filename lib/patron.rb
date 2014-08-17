class Patron

  attr_reader :id, :name, :phone_number

  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:name]
    @phone_number = attributes[:phone_number]
  end

end
