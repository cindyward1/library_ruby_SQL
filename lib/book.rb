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

  def ==(another_book)
    self.title == another_book.title && self.isbn_10 == another_book.isbn_10
  end

  def save
    book = DB.exec("INSERT INTO book (title, isbn_10) VALUES ('#{self.title}', '#{isbn_10}') " +
                      "RETURNING id;")
    @id = book.first['id'].to_i
  end

end