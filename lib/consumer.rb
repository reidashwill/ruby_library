class Consumer
  attr_reader :id
  attr_accessor :name

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end
  
  def self.all
    returned_consumers = DB.exec("SELECT * FROM consumers")
    consumers = []
    returned_consumers.each do |consumer|
      name = consumer.fetch("name")
      id = consumer.fetch("id").to_i
      consumers.push(Book.new({:name => name, :id => id}))
    end
    consumers
  end

  def self.clear 
    DB.exec("DELETE FROM consumers *")
  end

  def save
    result = DB.exec("INSERT INTO consumers (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.find(id)
    consumer = DB.exec("SELECT * FROM consumers WHERE id = #{id};").first
    name = consumer.fetch('name')
    id = consumer.fetch('id').to_i
    Consumer.new({:name => name, :id => id})
  end

  def update(name)
    @name = name
    DB.exec("UPDATE consumers SET name = '#{name}' WHERE id = #{id};")
  end

  def delete
    DB.exec("DELETE FROM checkouts WHERE consumer_id = #{@id}")
    DB.exec("DELETE FROM consumers WHERE id = #{@id};")
  end

  def ==(consumer_to_compare)
    self.name() == consumer_to_compare.name()
  end
  
  def self.search(search_name)
    consumer_names = Consumer.all.map { |a| a.name.downcase }
    result = []
    names = consumer_names.grep(/#{search_name.downcase}/)
    names.each do |n|
      consumer = DB.exec("SELECT * FROM consumers WHERE lower(name) = '#{n}'").first
      name = consumer.fetch("name")
      id = consumer.fetch("id")
      return_consumer = Consumer.new({:name => name, :id => id})
      result.push(return_consumer)
    end
    result
  end

  def checkout(book_id)
    DB.exec("INSERT INTO checkouts (consumer_id, book_id) VALUES (#{id},#{book_id});")
  end

  def checked_out
    Book.find_by_consumer(self.id)
  end




end  