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
      @phone_number = results['phone_number']
      patrons << Patron.new({:id=>@id, :name=>@name, :phone_number=>@phone_number})
    end
    patrons
  end

  def self.get_by_id(patron_id)
    results = DB.exec("SELECT * FROM patron WHERE id = #{patron_id};")
    patrons = []
    results.each do |results|
    	@id = results['id'].to_i
      @name = results['name']
      @phone_number = results['phone_number']
      patrons << Patron.new({:id=>@id, :name=>@name, :phone_number=>@phone_number})
    end
    patrons
  end

  def self.get_by_name(patron_name)
    results = DB.exec("SELECT * FROM patron WHERE name = '#{patron_name}';")
    patrons = []
    results.each do |results|
      @id = results['id'].to_i
      @name = results['name']
      @phone_number = results['phone_number']
      patrons << Patron.new({:id=>@id, :name=>@name, :phone_number=>@phone_number})
     end
    patrons
  end

	def self.get_by_phone_number(patron_phone_number)
    results = DB.exec("SELECT * FROM patron WHERE phone_number = '#{patron_phone_number}';")
    patrons = []
    results.each do |results|
      @id = results['id'].to_i
      @name = results['name']
      @phone_number = results['phone_number']
      patrons << Patron.new({:id=>@id, :name=>@name, :phone_number=>@phone_number})
    end
    patrons
  end

  def ==(another_patron)
    self.name == another_patron.name
  end

  def save
    patron = DB.exec("INSERT INTO patron (name, phone_number) VALUES ('#{self.name}', '#{self.phone_number}') " +
    								 "RETURNING id;")
    @id = patron.first['id'].to_i
  end

  def update_name(name)
    DB.exec("UPDATE patron SET name = '#{name}' WHERE id = #{self.id};")
  end

  def update_phone_number(phone_number)
    DB.exec("UPDATE patron SET phone_number = '#{phone_number}' WHERE id = #{self.id};")
  end

  def delete
    DB.exec("DELETE FROM patron WHERE id = #{self.id}")
  end

  def count_checkouts
  	results = DB.exec("SELECT COUNT(id) from checkout WHERE checkin_date = TO_DATE('00/00/0000', 'MM/DD/YYYY') and patron_id = #{self.id};") 
    counts = []
    results.each do |results|
      count = results['count'].to_i
      counts << count
    end
    counts
  end


  def count_overdue(today_date)
  	results = DB.exec("SELECT COUNT(id) from checkout WHERE due_date < TO_DATE('#{today_date}', 'MM/DD/YYYY') AND " +
                      "checkin_date = TO_DATE('00/00/0000', 'MM/DD/YYYY') and patron_id = #{self.id};") 
    counts = []
    results.each do |results|
      count = results['count'].to_i
      counts << count
    end
    counts
  end

end
