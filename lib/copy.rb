class Copy

  attr_reader :id, :book_id, :checkout_id

  def initialize(attributes)
    @id = attributes[:id]
    @book_id = attributes[:book_id]
    @checkout_id = attributes[:checkout_id]
  end

  def self.all
    results = DB.exec("SELECT * from copy;")
    copies = []
    results.each do |results|
      @id = results['id'].to_i
      @checkout_id = results['checkout_id'].to_i
      @book_id = results['book_id'].to_i
      copies << Copy.new({:id=>@id, :checkout_id=>@checkout_id, :book_id=>@book_id})
    end
    copies
  end

  def self.get_by_id(id)
    results = DB.exec("SELECT * from copy WHERE id = #{id};")
    copies = []
    results.each do |results|
      @id = results['id'].to_i
      @checkout_id = results['checkout_id'].to_i
      @book_id = results['book_id'].to_i
      copies << Copy.new({:id=>@id, :checkout_id=>@checkout_id, :book_id=>@book_id})
    end
    copies
  end

  def self.get_by_checkout_id(checkout_id)
    results = DB.exec("SELECT * from copy WHERE checkout_id = #{checkout_id};")
    copies = []
    results.each do |results|
      @id = results['id'].to_i
      @checkout_id = results['checkout_id'].to_i
      @book_id = results['book_id'].to_i
      copies << Copy.new({:id=>@id, :checkout_id=>@checkout_id, :book_id=>@book_id})
    end
    copies
  end

  def self.get_by_book_id(book_id) # find a book that's not checked out
    results = DB.exec("SELECT * from copy WHERE book_id = #{book_id} and checkout_id = 0;")
    copies = []
    results.each do |results|
      @id = results['id'].to_i
      @checkout_id = results['checkout_id'].to_i
      @book_id = results['book_id'].to_i
      copies << Copy.new({:id=>@id, :checkout_id=>@checkout_id,
                                          :book_id=>@book_id})
    end
    copies
  end

	def self.get_by_id(id)
    results = DB.exec("SELECT * from copy WHERE id = #{id};")
    copies = []
    results.each do |results|
      @id = results['id'].to_i
      @checkout_id = results['checkout_id'].to_i
      @book_id = results['book_id'].to_i
      copies << Copy.new({:id=>@id, :checkout_id=>@checkout_id, :book_id=>@book_id})
    end
    copies
  end

  def self.get_by_checkout_id(checkout_id)
    results = DB.exec("SELECT * from copy WHERE checkout_id = #{checkout_id};")
    copies = []
    results.each do |results|
      @id = results['id'].to_i
      @checkout_id = results['checkout_id'].to_i
      @book_id = results['book_id'].to_i
      copies << Copy.new({:id=>@id, :checkout_id=>@checkout_id, :book_id=>@book_id})
    end
    copies
  end

  def self.get_by_book_id_not_checked_out(book_id)
    results = DB.exec("SELECT * from copy WHERE book_id = #{book_id} and checkout_id = 0;")
    copies = []
    results.each do |results|
      @id = results['id'].to_i
      @checkout_id = results['checkout_id'].to_i
      @book_id = results['book_id'].to_i
      copies << Copy.new({:id=>@id, :checkout_id=>@checkout_id,
                                          :book_id=>@book_id})
    end
    copies
  end

	def self.get_by_checkout_id(checkout_id)
    results = DB.exec("SELECT * from copy WHERE checkout_id = #{checkout_id};")
    copies = []
    results.each do |results|
      @id = results['id'].to_i
      @checkout_id = results['checkout_id'].to_i
      @book_id = results['book_id'].to_i
      copies << Copy.new({:id=>@id, :checkout_id=>@checkout_id,
                                          :book_id=>@book_id})
    end
    copies
  end

  def ==(another_copy)
    self.checkout_id == another_copy.checkout_id && self.book_id == another_copy.book_id
  end

  def save
    copy = DB.exec("INSERT INTO copy (checkout_id, book_id) VALUES (#{self.checkout_id}, " +
                                     "#{self.book_id}) RETURNING id;")
    @id = copy.first['id'].to_i
  end

  def check_out(checkout_id)
    DB.exec("UPDATE copy SET checkout_id = '#{checkout_id}' WHERE id = #{self.id};")
  end

  def check_in
    DB.exec("UPDATE copy SET checkout_id = 0 WHERE id = #{self.id};")
  end

	def delete
    DB.exec("DELETE FROM copy WHERE id = #{self.id}")
  end
  
end
