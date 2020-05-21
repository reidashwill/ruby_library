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
  if @results = Book.search(params[:book_search])
  erb(:search_results)
  else 
    erb(:error)
  end
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

get('/book/:id/checkout') do
  @book = Book.find(params[:id].to_i())
  erb(:checkout)
end

get('/books/:id/edit') do
  @book = Book.find(params[:id].to_i())
  erb(:book_edit)
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
