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
  
#   def self.find_by_author
#     books = []
#     returned_books = DB.exec("SELECT athletes.* FROM sponsors
# JOIN endorsements ON (sponsors.id = endorsements.sponsor_id)
# JOIN athletes ON (endorsements.athlete_id = athletes.id)
# WHERE sponsors.id = 1;")
#     returned_books.each() do |book|


  # def self.find_by_author(auth_id)
  #   books = []
  #   returned_books = DB.exec("SELECT * FROM authors_books WHERE author_id = #{auth_id};")
  #   binding.pry
  #   returned_books.each() do |book|
  #     # name = book.fetch("name")
  #     book.any?
  #       book_id = book.fetch("id").to_i
  #       book_to_push = DB.exec("select * FROM books WHERE id = #{book_id}")
  #     name = book.fetch("name")
  #     id = book_to_push.fetch("id")
  #     books.push(Book.new({:name => name, :id => id}))
  #   end
  #  books
  # end

  


# def self.find_by_artist(art_id)
  #   albums = []
  #   returned_albums = DB.exec("SELECT * FROM albums_artists WHERE artist_id = #{art_id};")
  #   returned_albums.each() do |album|
  #   name = album.fetch("name")
  #   id = album.fetch('id').to_i
  #   albums.push(Album.new({:name => name, :artist_id => art_id, :id => id}))
  #   end
  #   albums
  # end
