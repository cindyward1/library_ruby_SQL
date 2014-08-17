class Book

  attr_reader :id, :title, :isbn_10

  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
    @isbn_10 = attributes[:isbn_10]
  end

end