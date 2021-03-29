class Dog

attr_accessor :name, :breed
attr_reader :id

def initialize(id=nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
end

def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
        )
        SQL
    DB[:conn].execute(sql)
  end


  def self.drop_table
    sql =  <<-SQL
     DROP TABLE IF EXISTS dogs 
        SQL
    DB[:conn].execute(sql)
    
  end

  def save
        sql = <<-SQL
          INSERT INTO dogs (name, breed)
          VALUES (?, ?)
        SQL
    
        DB[:conn].execute(sql, self.name, self.breed)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      
  end

  def self.create(name, breed)
    dog = Dog.new(name, breed)
    dog.save
   dog
  end

  def self.find_by_name(name:)
    sql = "SELECT * FROM dogs WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    Dog.new(result[0], result[1], result[2])
  end
  def self.find_by_id(id)
    sql = "SELECT * FROM dogs WHERE id = ?"
    result = DB[:conn].execute(sql, id)[0]
    Dog.new(result[0], result[1], result[2])
  end


  def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE name = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.name)
  end

end