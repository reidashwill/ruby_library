require('sinatra')
require("sinatra/reloader")
require('./lib/author')
require('./lib/book')
require('./lib/consumer')
require('pry')
require('pg')
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "library"})

get('/')do
  redirect to('/home')
end

get('/home') do
  erb(:index)
end

get('/librarian') do
  @books = Book.all
  erb(:librarian)
end

post('/librarian')do
book_name = params[:book_name]
book_author = params[:book_author]
book = Book.new({:name => book_name, :id => nil})
book.save
author = Author.new({:name => book_author, :id => nil})
author.save
book.bind_to_author(author.id)
redirect to('/librarian')
end

get('/consumer') do
  erb(:consumer)
end

get('/books/search_results') do
  @results = Book.search(params[:book_search])
  erb(:search_results)
  end


get('/books') do
  @books = Book.all()
  erb(:books)
end

get('/books/:id')do
  @book = Book.find(params[:id].to_i())
  erb(:book)
end

get('/authors') do
  @authors = Author.all()
  erb(:authors)
end

get('/authors/search_results') do
  @author_results = Author.search(params[:author_search])
    erb(:search_results)
    end
  

get('/book/:id/checkout') do
  @book = Book.find(params[:id].to_i())
  erb(:checkout)
end

post('/books/:id/add_author') do
  @book = Book.find(params[:id].to_i())
  book_author = params[:book_author]
  author = Author.new({:name => book_author, :id => nil})
  author.save
  @book.bind_to_author(author.id)
  redirect to('/librarian')
end

get('/books/:id/edit') do
  @book = Book.find(params[:id].to_i())
  erb(:book_edit)
end

get('/books/:id/checkout') do
  @book = Book.find(params[:id].to_i())
  erb(:checkout)
end

post('/books/:id/checkout') do
  username = params[:username]
  
  book = Book.find(params[:id].to_i)

end

patch('/books/:id/edit') do
  @book = Book.find(params[:id].to_i)
  @book.update(params[:book_name])
  redirect to('/librarian')
end

delete('/books/:id') do
  @book = Book.find(params[:id].to_i)
  @book.delete()
  redirect to('/librarian')
end

post('/consumer/add') do
  username = params[:username]
  consumer = Consumer.new({:name => username, :id => nil})
  consumer.save()
  @books = Book.all
  erb(:books)
end