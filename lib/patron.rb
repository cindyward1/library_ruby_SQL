class Patron

  attr_reader :id, :name, :phone_number

  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:name]
    @phone_number = attributes[:phone_number]
  end

def self.all
    results = DB.exec("SELECT * FROM patron ORDER BY name;")
    patrons = []
    results.each do |results|
      @id = results['id'].to_i
      @name = results['name']
      patrons << Patron.new({:id=>@id, :name=>@name})
    end
    patrons
  end

  def ==(another_patron)
    self.name == another_patron.name
  end

  def save
    patron = DB.exec("INSERT INTO patron (name) VALUES ('#{self.name}') RETURNING id;")
    @id = patron.first['id'].to_i
  end

end
