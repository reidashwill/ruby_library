require 'spec_helper'

describe '#Consumer' do
  
  describe('#save') do
  it("saves an consumer") do
    consumer = Consumer.new({:name => "Tyler Bowerman", :id => nil})
    consumer.save()
    consumer2 = Consumer.new({:name => "Reid Ashwill", :id => nil}) # nil added as second argument
    consumer2.save()
    expect(Consumer.all).to(eq([consumer, consumer2]))
    end
  end

  describe('.all') do
  it("returns an empty array when there are no consumers") do
    expect(Consumer.all).to(eq([]))
    end
  end

  describe('.clear') do
  it("clears all consumers") do
    consumer = Consumer.new({:name => "Reid Ashwill", :id => nil})
    consumer.save()
    consumer2 = Consumer.new({:name => "Tyler Bowerman", :id => nil})
    consumer2.save()
    Consumer.clear()
    expect(Consumer.all).to(eq([]))
    end
  end

  describe('#==') do
  it("is the same consumer if it has the same attributes as another consumer") do
    consumer = Consumer.new({:name => "Tyler Bowerman", :id => nil})
    consumer2 = Consumer.new({:name => "Tyler Bowerman", :id => nil})
    expect(consumer).to(eq(consumer2))
    end
  end

  describe('.find') do
    it("finds a consumer by id") do
      consumer = Consumer.new({:name => "Reid Ashwill", :id => nil})
      consumer.save()
      consumer2 = Consumer.new({:name => "Tyler Bowerman", :id => nil})
      consumer2.save()
      expect(Consumer.find(consumer.id)).to(eq(consumer))
    end
  end

  describe('#update') do
    it("updates a consumer search by id") do
      consumer = Consumer.new({:name => "Reid Ashwill", :id => nil})
      consumer.save()
      consumer.update("Tyler Bowerman")
      expect(consumer.name).to(eq("Tyler Bowerman"))
    end
  end

  describe('#delete') do
    it("deletes a consumer by id") do
      consumer = Consumer.new({:name => "Reid Ashwill", :id => nil})
      consumer.save()
      consumer2 = Consumer.new({:name => "Tyler Bowerman", :id => nil})
      consumer2.save()
      consumer.delete()
      expect(Consumer.all).to(eq([consumer2]))
    end
  end

  describe('.search') do
    it("will allow you to search for a consumer") do
      consumer = Consumer.new({:name => "Reid Ashwill", :id => nil})
      consumer.save()
      consumer2 = Consumer.new({:name => "Tyler Bowerman", :id => nil})
      consumer2.save()
      expect(Consumer.search(consumer.name)).to(eq([consumer]))
    end
  end


end