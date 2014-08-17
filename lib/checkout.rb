class Checkout

  attr_reader :id, :patron_id, :copy_id, :checkout_date, :due_date

  def initialize(attributes)
    @id = attributes[:id]
    @patron_id = attributes[:patron_id]
    @copy_id = attributes[:copy_id]
    @checkout_date = attributes[:checkout_date]
    @due_date = attributes[:due_date]
  end

end
