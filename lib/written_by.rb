class Written_by

  attr_reader :id, :author_id, :book_id

  def initialize(attributes)
    @id = attributes[:id]
    @author_id = attributes[:author_id]
    @book_id = attributes[:book_id]
  end

end
