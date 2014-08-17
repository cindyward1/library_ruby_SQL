class Book

  attr_reader :id, :title, :isbn_10

  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
    @isbn_10 = attributes[:isbn_10]
  end

  def self.all
    results = DB.exec("SELECT * FROM book ORDER BY title;")
    books = []
    results.each do |results|
      @id = results['id'].to_i
      @title = results['title']
      @isbn_10 = results['isbn_10']
      books << Book.new({:id=>@id, :title=>@title, :isbn_10=>@isbn_10})
    end
    books
  end

  def self.get_by_id(book_id)
    results = DB.exec("SELECT * FROM book WHERE id = #{book_id};")
    books = []
    results.each do |results|
      @id = results['id'].to_i
      @title = results['title']
      @isbn_10 = results['isbn_10']
      books << Book.new({:id=>@id, :title=>@title, :isbn_10=>@isbn_10})
    end
    books
  end

  def self.get_by_title(book_title)
    results = DB.exec("SELECT * FROM book WHERE title = '#{book_title}';")
    books = []
    results.each do |results|
      @id = results['id'].to_i
      @title = results['title']
      @isbn_10 = results['isbn_10']
      books << Book.new({:id=>@id, :title=>@title, :isbn_10=>@isbn_10})
    end
    books
  end

  def self.get_by_isbn_10(book_isbn_10)
    results = DB.exec("SELECT * FROM book WHERE isbn_10 = '#{book_isbn_10}';")
    books = []
    results.each do |results|
      @id = results['id'].to_i
      @title = results['title']
      @isbn_10 = results['isbn_10']
      books << Book.new({:id=>@id, :title=>@title, :isbn_10=>@isbn_10})
    end
    books
  end

  def ==(another_book)
    self.title == another_book.title && self.isbn_10 == another_book.isbn_10
  end

  def save
    book = DB.exec("INSERT INTO book (title, isbn_10) VALUES ('#{self.title}', '#{isbn_10}') " +
                      "RETURNING id;")
    @id = book.first['id'].to_i
  end

  def update_title(title)
    DB.exec("UPDATE book SET title = '#{title}' WHERE id = #{self.id};")
  end

  def update_isbn_10(isbn_10)
    DB.exec("UPDATE book SET isbn_10 = '#{isbn_10}' WHERE id = #{self.id};")
  end

  def delete
    DB.exec("DELETE FROM book WHERE id = #{self.id}")
  end

  def count_copies
  	result = DB.exec("SELECT COUNT(copies.book_id) AS number_of_copies FROM copy copies WHERE book_id = #{self.id};")
  	number_of_copies = result.first['number_of_copies']
  	number_of_copies
  end

  def find_authors
  	results = DB.exec("SELECT author.* FROM book JOIN written_by ON (written_by.book_id = book.id) " +
                      "JOIN author ON (author.id = written_by.author_id) WHERE book.id = #{self.id} " +
                      "ORDER BY author.name;")
    author_name_array = []
    results.each do |author|
    	author_name = author['name']
    	author_name_array << author_name
    end
    author_name_array
  end

end