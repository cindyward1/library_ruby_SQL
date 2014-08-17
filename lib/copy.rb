class Copy

  attr_reader :id, :book_id, :checkout_id

  def initialize(attributes)
    @id = attributes[:id]
    @book_id = attributes[:book_id]
    @checkout_id = attributes[:checkout_id]
  end

end
