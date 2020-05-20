require 'spec_helper'

describe'#Book' do
  
  describe('#save') do
    it("saves a book") do
      book = Book.new({:name => "Foundation", :id => nil})
      book.save()
      book2 = Book.new ({:name => "Invivibles", :id => nil})
      book2.save()
      expect(Book.all).to(eq([book, book2]))
    end
  end

  describe('.all') do
    it("returns an empty array when there are no books") do
      expect(Book.all).to(eq([]))
    end
  end

  describe('.clear') do
    it("clears all books") do
      book = Book.new({:name => "Foundation", :id => nil})
      book.save()
      book2 = Book.new({:name => "Invisibles", :id => nil})
      book2.save()
      Book.clear()
      expect(Book.all).to(eq([]))
    end
  end

  describe('#==') do
    it("is the same book if it has the same attributes as another author") do
      book = Book.new({:name => "Foundation", :id => nil})
      book2 = Book.new({:name => "Foundation", :id => nil})
      expect(book).to(eq(book2))
    end
  end

  describe('.find') do
    it("finds an book by id") do
      book = Book.new({:name => "Foundation", :id => nil})
      book.save()
      book2 = Book.new({:name => "Invisibles", :id => nil})
      book2.save()
      expect(Book.find(book.id)).to(eq(book))
    end
  end

  describe('#update') do
    it("updates an authorsearch by id") do
      book = Book.new({:name => "Foundation", :id => nil})
      book.save()
      book.update("Invisibles")
      expect(book.name).to(eq("Invisibles"))
    end
  end

  describe('#delete') do
    it("deletes an author by id") do
      book = Book.new({:name => "Foundation", :id => nil})
      book.save()
      book2 = Book.new({:name => "Invisibles", :id => nil})
      book2.save()
      book.delete()
      expect(Book.all).to(eq([book2]))
    end
  end

  describe('.search') do
    it("will allow you to search for an author") do
      book = Book.new({:name => "Foundation", :id => nil})
      book.save()
      book2 = Book.new({:name => "Invibibles", :id => nil})
      book2.save()
      expect(Book.search(book.name)).to(eq([book]))
    end
  end

end