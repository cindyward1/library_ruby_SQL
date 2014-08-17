class Checkout

  attr_reader :id, :patron_id, :copy_id, :checkout_date, :due_date

  def initialize(attributes)
    @id = attributes[:id]
    @patron_id = attributes[:patron_id]
    @copy_id = attributes[:copy_id]
    @checkout_date = attributes[:checkout_date]
    @due_date = attributes[:due_date]
  end

	def self.all
    results = DB.exec("SELECT id, patron_id, copy_id, TO_CHAR(checkout_date, 'MM/DD/YYYY') AS checkout_date_char, " +
    									"TO_CHAR(due_date, 'MM/DD/YYYY') AS due_date_char from checkout;")
    checkouts = []
    results.each do |results|
      @id = results['id'].to_i
      @patron_id = results['patron_id'].to_i
      @copy_id = results['copy_id'].to_i
      @checkout_date = results['checkout_date_char']
      @due_date = results['due_date_char']
      checkouts << Checkout.new({:id=>@id, :patron_id=>@patron_id, :copy_id=>@copy_id, :checkout_date=>@checkout_date, :due_date=>@due_date})
    end
    checkouts
  end

	def ==(another_checkout)
    self.copy_id == another_checkout.copy_id && self.patron_id == another_checkout.patron_id
  end

  def save
    copy = DB.exec("INSERT INTO checkout (copy_id, patron_id, checkout_date, due_date) VALUES (#{self.copy_id}, " +
                                     "#{self.patron_id}, TO_DATE('#{checkout_date}', 'MM/DD/YYYY'), TO_DATE('#{due_date}', 'MM/DD/YYYY')) " +
                                     "RETURNING id;")
    @id = copy.first['id'].to_i
  end

end
