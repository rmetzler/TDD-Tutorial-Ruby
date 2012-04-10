class HanoiException < StandardError; end

class Stack
  
  def initialize
    @items = []
  end
  
  def empty?
    @items.empty?
  end
  
  def push(item)
    if (not empty?) && (item < @items.last)
      raise HanoiException.new
    end
    
    @items.push(item)
  end
  
  def pop
    if empty?
      raise HanoiException.new
    end
    
    @items.pop
  end
  
  def to_s
    @items.clone.unshift('|').join('-')
  end
  
  
end

describe Stack do
  
  before(:each) do
    @stack = Stack.new
  end
  
  it "is empty when created" do
    @stack.should be_empty
  end
  
  it "can push and pop, and it should be the same item" do
    item1 = {}
    @stack.push item1
    item2 = @stack.pop
    
    item2.should equal item1
  end  
  
  it "should not pop when empty" do
    lambda {@stack.pop}.should raise_error
  end
  
  it "should not push when to small" do
    @stack.push 10
    lambda {@stack.push 9}.should raise_error
  end
      
end

  
class Hanoi
  
  def initialize(discs=3, &block)
    @stacks = {
      :a => Stack.new,
      :b => Stack.new,
      :c => Stack.new,
    }
    
    discs.times { |i| @stacks[:a].push i}
    
    @win_block = block
    
  end
  
  def stack(name)
    @stacks[name]
  end
  
  def move(from, to)
    disc = @stacks[from].pop
    @stacks[to].push disc
    
    if won?
      winning
    end
    
    self
  end
  
  def won?
    @stacks[:a].empty? &&
    @stacks[:b].empty? &&
    ! @stacks[:c].empty?
  end
  
  def winning
    @win_block.call unless @win_block == nil
  end
  
end




describe Hanoi do

  before(:each) do
    @hanoi = Hanoi.new
  end
  
  it "has only discs on stack A after starting" do
    @hanoi.stack(:a).should_not be_empty
    @hanoi.stack(:b).should be_empty
    @hanoi.stack(:c).should be_empty  
  end
  
  it "should be able to move items" do
    @hanoi.stack(:b).should be_empty
    @hanoi.move(:a, :b)
    @hanoi.stack(:b).should_not be_empty
  end 
  
  it "should not allow to move a disc from an empty stack" do
    @hanoi.stack(:b).should be_empty
    lambda{@hanoi.move(:b, :c)}.should raise_error
  end
  
  it "should not be able to put a bigger disk on a smaller disk" do
    @hanoi.move(:a, :b)
    #die zweite disk ist größer als die oberste 
    lambda {@hanoi.move(:a, :b)}.should raise_error
  end

  it "should be able to win" do
    has_won = "not yet"
    @hanoi = Hanoi.new 2 do
      @hanoi.should be_won
      has_won = "I win"
    end
    
    @hanoi.should_not be_won
    @hanoi.move(:a, :b)
    @hanoi.should_not be_won
    @hanoi.move(:a, :c)
    @hanoi.should_not be_won
    @hanoi.move(:b, :c)
    
    has_won.should == "I win"
  end
  
end

def printHanoi( hanoi )
  [:a, :b, :c].each do |s|
    puts hanoi.stack(s)
  end
end

printHanoi Hanoi.new

