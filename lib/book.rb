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
    DB.exec("DELETE FROM checkouts WHERE book_id = #{@id};")
    DB.exec("DELETE FROM authors_books WHERE book_id = #{@id};")
    DB.exec("DELETE FROM books WHERE id = #{@id};")
  end

  def bind_to_author(author_id)
    DB.exec("INSERT INTO authors_books (author_id, book_id) VALUES (#{author_id}, #{@id});") 
  end

  def ==(book_to_compare)
    self.name() == book_to_compare.name()
  end

  def self.search(search_name)
    @books = DB.exec("SELECT * FROM books WHERE name ILIKE '%#{search_name}%';")
    @result = []
    @books.each do |b|
      name = b.fetch("name")
      id = b.fetch("id")
      @result.push(Book.new({:name => name, :id => id}))
    end
    @result
  end

  def self.find_by_consumer(c_id)
    books = []
    checkouts = DB.exec("SELECT books.* FROM books JOIN checkouts ON (books.id = checkouts.book_id) JOIN consumers ON (checkouts.consumer_id = consumers.id) WHERE consumers.id = #{c_id}")
    checkouts.each() do |b|
      name = b.fetch("name")
      id = b.fetch("id").to_i
      books.push(Book.new({:name => name, :id => id}))
    end
    books
  end


  def self.find_by_author(auth_id)
    books= []
    authors_books = DB.exec("SELECT books.* FROM books JOIN authors_books ON (books.id = authors_books.book_id) JOIN authors ON (authors_books.author_id = authors.id) WHERE authors.id = #{auth_id}")
    authors_books.each() do |b|
      name = b.fetch("name")
      id = b.fetch("id").to_i
      books.push(Book.new({:name => name, :id => id}))
    end
    books
  end

  def authors
    Author.find_by_book(self.id)
  end
end
