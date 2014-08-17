class Written_by

  attr_reader :id, :author_id, :book_id

  def initialize(attributes)
    @id = attributes[:id]
    @author_id = attributes[:author_id]
    @book_id = attributes[:book_id]
  end

def self.all
    results = DB.exec("SELECT * from written_by;")
    written_by_array = []
    results.each do |results|
      @id = results['id'].to_i
      @author_id = results['author_id'].to_i
      @book_id = results['book_id'].to_i
      written_by_array << Written_by.new({:id=>@id, :author_id=>@author_id,
                                          :book_id=>@book_id})
    end
    written_by_array
  end

  def self.get_by_author_id(author_id)
    results = DB.exec("SELECT * from written_by WHERE author_id = #{author_id};")
    written_by_array = []
    results.each do |results|
      @id = results['id'].to_i
      @author_id = results['author_id'].to_i
      @book_id = results['book_id'].to_i
      written_by_array << Written_by.new({:id=>@id, :author_id=>@author_id,
                                          :book_id=>@book_id})
    end
    written_by_array
  end

  def self.get_by_book_id(book_id)
    results = DB.exec("SELECT * from written_by WHERE book_id = #{book_id};")
    written_by_array = []
    results.each do |results|
      @id = results['id'].to_i
      @author_id = results['author_id'].to_i
      @book_id = results['book_id'].to_i
      written_by_array << Written_by.new({:id=>@id, :author_id=>@author_id,
                                          :book_id=>@book_id})
    end
    written_by_array
  end

  def ==(another_written_by)
    self.author_id == another_written_by.author_id && self.book_id == another_written_by.book_id
  end

  def save
    written_by = DB.exec("INSERT INTO written_by (author_id, book_id) VALUES (#{self.author_id}, " +
                                     "#{self.book_id}) RETURNING id;")
    @id = written_by.first['id'].to_i
  end


	def delete
    DB.exec("DELETE FROM written_by WHERE id = #{self.id}")
  end

end
