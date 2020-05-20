require 'spec_helper'

describe '#Author' do

  describe('#save') do
    it("saves an author") do
      author = Author.new({:name => "Issac Asimov", :id => nil})
      author.save()
      author2 = Author.new({:name => "Grant Morrison", :id => nil}) # nil added as second argument
      author2.save()
      expect(Author.all).to(eq([author, author2]))
    end
  end
  
  describe('.all') do
    it("returns an empty array when there are no authors") do
      expect(Author.all).to(eq([]))
    end
  end

  describe('.clear') do
    it("clears all authors") do
      author = Author.new({:name => "Issac Asimov", :id => nil})
      author.save()
      author2 = Author.new({:name => "Grant Morrison", :id => nil})
      author2.save()
      Author.clear()
      expect(Author.all).to(eq([]))
    end
  end

  describe('#==') do
    it("is the same author if it has the same attributes as another author") do
      author = Author.new({:name => "Issac Asimov", :id => nil})
      author2 = Author.new({:name => "Issac Asimov", :id => nil})
      expect(author).to(eq(author2))
    end
  end

  describe('.find') do
    it("finds an author by id") do
      author = Author.new({:name => "Grant Morrison", :id => nil})
      author.save()
      author2 = Author.new({:name => "Issac Asimov", :id => nil})
      author2.save()
      expect(Author.find(author.id)).to(eq(author))
    end
  end

  describe('#update') do
    it("updates an authorsearch by id") do
      author1 = Author.new({:name => "Issac Asimov", :id => nil})
      author1.save()
      author1.update("Grant Morrison")
      expect(author1.name).to(eq("Grant Morrison"))
    end
  end

  describe('#delete') do
    it("deletes an author by id") do
      author1 = Author.new({:name => "Issac Asimov", :id => nil})
      author1.save()
      author2 = Author.new({:name => "Grant Morrison", :id => nil})
      author2.save()
      author1.delete()
      expect(Author.all).to(eq([author2]))
    end
  end

  describe('.search') do
    it("will allow you to search for an author") do
      author1 = Author.new({:name => "Issac Asimov", :id => nil})
      author1.save()
      author2 = Author.new({:name => "Grant Morrison", :id => nil})
      author2.save()
      expect(Author.search(author1.name)).to(eq([author1]))
    end
  end

end