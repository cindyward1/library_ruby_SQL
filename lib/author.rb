class Author

  attr_reader :id, :name

  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:name]
  end

  def self.all
    results = DB.exec("SELECT * FROM author ORDER BY name;")
    authors = []
    results.each do |results|
      @id = results['id'].to_i
      @name = results['name']
      authors << Author.new({:id=>@id, :name=>@name})
    end
    authors
  end

  def self.get_by_id(author_id)
    results = DB.exec("SELECT * FROM author WHERE id = #{author_id};")
    authors = []
    results.each do |results|
      @id = results['id'].to_i
      @name = results['name']
      authors << Author.new({:id=>@id, :name=>@name})
    end
    authors
  end

  def self.get_by_name(author_name)
    results = DB.exec("SELECT * FROM author WHERE name = '#{author_name}';")
    authors = []
    results.each do |results|
      @id = results['id'].to_i
      @name = results['name']
      authors << Author.new({:id=>@id, :name=>@name})
    end
    authors
  end

  def ==(another_author)
    self.name == another_author.name
  end

  def save
    author = DB.exec("INSERT INTO author (name) VALUES ('#{self.name}') RETURNING id;")
    @id = author.first['id'].to_i
  end

end