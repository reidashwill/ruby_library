class Book
  attr_reader :id
  attr_accessor :name

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def self.all 
    returned_books = DB.exec("SELECT * FROM  books")
    books = []
    returned_books.each do |book|
      name = book.fetch("name")
      id = book.fetch("id").to_i
      books.push(Book.new({:name => name, :id => id}))
    end
    books
  end

  def self.clear
    DB.exec("DELETE FROM books *")
  end

  def save
    result = DB.exec("INSERT INTO books (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.find(id)
    book = DB.exec("SELECT * FROM books WHERE id = #{id};").first
    name = book.fetch('name')
    id = book.fetch('id').to_i
    Book.new({:name => name, :id => id})
  end

  def update(name)
    @name = name
    DB.exec("UPDATE books SET name = '#{name}' WHERE id = #{id};")
  end

  def delete 
    DB.exec("DELETE FROM authors_books WHERE book_id = #{@id};")
    DB.exec("DELETE FROM books WHERE id = #{@id};")
  end

  def ==(book_to_compare)
    self.name() == book_to_compare.name()
  end

  def self.search(search_name)
    book_names = Book.all.map { |b| b.name.downcase }
    result = []
    names = book_names.grep(/#{search_name.downcase}/)
    names.each do |n|
      book = DB.exec("SELECT * FROM books WHERE lower(name) = '#{n}'").first
      name = book.fetch("name")
      id = book.fetch("id")
      return_book = Book.new({:name => name, :id => id})
      result.push(return_book)
    end
    result
  end
  
end
