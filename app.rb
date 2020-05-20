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
  erb(:librarian)
end

get('/consumer') do
  erb(:consumer)
end

get('/search_results') do
  erb(:search_results)
end

get('/books/search_results') do
  @book_results = Book.search(params[:book_search])
  redirect to('/search_results')
end

get('/books') do
  @books = Book.all()
  erb(:books)
end

get('/authors') do
  @authors = Author.all()
  erb(:authors)
end
