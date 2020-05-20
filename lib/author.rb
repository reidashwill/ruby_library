class Author
  attr_reader :id
  attr_accessor :name

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def self.all
    returned_authors = DB.exec("SELECT * FROM authors")
    authors = []
    returned_authors.each do |author|
      name = author.fetch("name")
      id = author.fetch("id").to_i
      authors.push(Author.new({:name => name, :id => id}))
    end
    authors
  end

  def self.clear
    DB.exec("DELETE FROM authors *")
  end

  def save
    result = DB.exec("INSERT INTO authors (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.find(id)
    author = DB.exec("SELECT * FROM authors WHERE id = #{id};").first
    name = author.fetch('name')
    id = author.fetch('id').to_i
    Author.new({:name => name, :id => id})
  end

  def update(name)
    @name = name
    DB.exec("UPDATE authors SET name = '#{name}' WHERE id = #{@id};")
  end 

  def bind_to_book(book_id)
    DB.exec("INSERT INTO authors_books (book_id, author_id) VALUES (#{book_id}, #{@id});")
  end

  # def update(attributes)
  #   if (attributes.has_key?(:name)) && (attributes.fetch(:name) != nil)
  #     @name = attributes.fetch(:name)
  #     DB.exec("UPDATE authors SET name = '#{@name}' WHERE id = #{@id};")
  #   elsif (attributes.has_key?(:author_name)) && (attributes.fetch(:author_name) != nil)
  #     author_name = attributes.fetch(:author_name)
  #     author = DB.exec("SELECT * FROM authors WHERE lower(name)='#{author_name.downcase}';").first
  #     if author != nil
  #       DB.exec("INSERT INTO authors_books (book_id, author_id) VALUES (#{@book['id'].to_i}, #{@id});")
  #     end
  #   end
  # end

  def delete 
    DB.exec("DELETE FROM authors_books WHERE author_id = #{@id};")
    DB.exec("DELETE FROM authors WHERE id = #{@id};")
  end

  def ==(author_to_compare)
    self.name() == author_to_compare.name()
  end

  def self.search(search_name)
    author_names = Author.all.map { |a| a.name.downcase }
    result = []
    names = author_names.grep(/#{search_name.downcase}/)
    names.each do |n|
      author = DB.exec("SELECT * FROM authors WHERE lower(name) = '#{n}'").first
      name = author.fetch("name")
      id = author.fetch("id")
      return_author = Author.new({:name => name, :id => id})
      result.push(return_author)
    end
    result
  end

  def books
    Book.find_by_author(self.id)
  end

end
