require "date"

class Checkout

  attr_reader :id, :patron_id, :copy_id, :checkout_date, :due_date, :checkin_date

  def initialize(attributes)
    @id = attributes[:id]
    @patron_id = attributes[:patron_id]
    @copy_id = attributes[:copy_id]
    @checkout_date = attributes[:checkout_date]
    @due_date = attributes[:due_date]
    @checkin_date = attributes[:checkin_date]
  end

	def self.all
    results = DB.exec("SELECT id, patron_id, copy_id, TO_CHAR(checkout_date, 'MM/DD/YYYY') AS checkout_date_char, " +
    									"TO_CHAR(checkin_date, 'MM/DD/YYYY') as checkin_date_char, " +
    									"TO_CHAR(due_date, 'MM/DD/YYYY') AS due_date_char from checkout;")
    checkouts = []
    results.each do |results|
      @id = results['id'].to_i
      @patron_id = results['patron_id'].to_i
      @copy_id = results['copy_id'].to_i
      @checkout_date = results['checkout_date_char']
      @checkin_date = results['checkin_date_char']
      @due_date = results['due_date_char']
      checkouts << Checkout.new({:id=>@id, :patron_id=>@patron_id, :copy_id=>@copy_id, :checkout_date=>@checkout_date, :checkin_date=>@checkin_date, :due_date=>@due_date})
    end
    checkouts
  end

  def self.get_by_id(checkout_id)
    results = DB.exec("SELECT id, patron_id, copy_id, TO_CHAR(checkout_date, 'MM/DD/YYYY') AS checkout_date_char, " +
                      "TO_CHAR(checkin_date, 'MM/DD/YYYY') as checkin_date_char, " +
                      "TO_CHAR(due_date, 'MM/DD/YYYY') AS due_date_char from checkout WHERE id = #{checkout_id};")
    checkouts = []
    results.each do |results|
      @id = results['id'].to_i
      @patron_id = results['patron_id'].to_i
      @copy_id = results['copy_id'].to_i
    	@checkout_date = results['checkout_date_char']
      @checkin_date = results['checkin_date_char']
      @due_date = results['due_date_char']
      checkouts << Checkout.new({:id=>@id, :patron_id=>@patron_id, :copy_id=>@copy_id, :checkout_date=>@checkout_date, :checkin_date=>@checkin_date, :due_date=>@due_date})
    end
    checkouts
  end

  def self.get_by_patron_id(patron_id)
    results = DB.exec("SELECT id, patron_id, copy_id, TO_CHAR(checkout_date, 'MM/DD/YYYY') AS checkout_date_char, " +
                      "TO_CHAR(checkin_date, 'MM/DD/YYYY') as checkin_date_char, " +
                      "TO_CHAR(due_date, 'MM/DD/YYYY') AS due_date_char from checkout WHERE patron_id = #{patron_id} " +
                      "ORDER BY checkin_date_char, checkout_date_char, due_date_char;")
    checkouts = []
    results.each do |results|
      @id = results['id'].to_i
      @patron_id = results['patron_id'].to_i
      @copy_id = results['copy_id'].to_i
      @checkout_date = results['checkout_date_char']
      @checkin_date = results['checkin_date_char']
      @due_date = results['due_date_char']
      checkouts << Checkout.new({:id=>@id, :patron_id=>@patron_id, :copy_id=>@copy_id, :checkout_date=>@checkout_date, 
                                 :checkin_date=>@checkin_date, :due_date=>@due_date})
    end
    checkouts
  end


	def self.get_by_copy_id(copy_id)
    results = DB.exec("SELECT id, patron_id, copy_id, TO_CHAR(checkout_date, 'MM/DD/YYYY') AS checkout_date_char, " +
                      "TO_CHAR(checkin_date, 'MM/DD/YYYY') as checkin_date_char, " +
                      "TO_CHAR(due_date, 'MM/DD/YYYY') AS due_date_char from checkout WHERE copy_id = #{copy_id};")
    checkouts = []
    results.each do |results|
      @id = results['id'].to_i
      @patron_id = results['patron_id'].to_i
      @copy_id = results['copy_id'].to_i
      @checkout_date = results['checkout_date_char']
      @checkin_date = results['checkin_date_char']
      @due_date = results['due_date_char']
      checkouts << Checkout.new({:id=>@id, :patron_id=>@patron_id, :copy_id=>@copy_id, :checkout_date=>@checkout_date, :checkin_date=>@checkin_date, :due_date=>@due_date})
    end
    checkouts
  end

  def self.get_overdue(today_date)
  	results = DB.exec("SELECT id, patron_id, copy_id, TO_CHAR(checkout_date, 'MM/DD/YYYY') AS checkout_date_char, " +
                      "TO_CHAR(checkin_date, 'MM/DD/YYYY') as checkin_date_char, " +
                      "TO_CHAR(due_date, 'MM/DD/YYYY') AS due_date_char from checkout WHERE due_date < TO_DATE('#{today_date}', 'MM/DD/YYYY');")
		checkouts = []
    results.each do |results|
      @id = results['id'].to_i
      @patron_id = results['patron_id'].to_i
      @copy_id = results['copy_id'].to_i
    	@checkout_date = results['checkout_date_char']
      @checkin_date = results['checkin_date_char']
      @due_date = results['due_date_char']
      checkouts << Checkout.new({:id=>@id, :patron_id=>@patron_id, :copy_id=>@copy_id, :checkout_date=>@checkout_date, :checkin_date=>@checkin_date, :due_date=>@due_date})
    end
    checkouts
  end

	def ==(another_checkout)
    self.copy_id == another_checkout.copy_id && self.patron_id == another_checkout.patron_id
  end

  def save
    copy = DB.exec("INSERT INTO checkout (copy_id, patron_id, checkout_date, checkin_date, due_date) VALUES (#{self.copy_id}, " +
                                     "#{self.patron_id}, TO_DATE('#{self.checkout_date}', 'MM/DD/YYYY'), " +
                                     "TO_DATE('#{self.checkin_date}', 'MM/DD/YYYY'), TO_DATE('#{self.due_date}', 'MM/DD/YYYY')) RETURNING id;")
    @id = copy.first['id'].to_i
  end

  def delete
    DB.exec("DELETE FROM checkout WHERE id = #{self.id}")
  end

  def check_in(today_date)
    DB.exec("UPDATE checkout SET checkin_date = TO_DATE('#{today_date}', 'MM/DD/YYYY') WHERE id = #{self.id};")
  end

end
