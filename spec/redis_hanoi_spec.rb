require File.join(File.dirname(__FILE__), 'spec_helper')

describe RedisHanoi do
  
  before(:each) do
    @hanoi = RedisHanoi.new
  end

  it "is possible to start Hanoi" do
    RedisHanoi.new
  end

  it "has only discs on rod A after starting" do
    @hanoi.rod(:a).should_not be_empty
    @hanoi.rod(:b).should be_empty
    @hanoi.rod(:c).should be_empty
  end  
  
  it "should be able to move discs to an empty rod" do
    @hanoi.rod(:b).should be_empty
    @hanoi.should be_allowed_move(:a, :b)
    @hanoi.move(:a, :b)
    @hanoi.rod(:b).should_not be_empty
  end

  it "should not allow to move a disc from an empty stack" do
    @hanoi.should_not be_allowed_move(:b, :c)
    lambda { @hanoi.move(:b, :c) }.should raise_error
  end
  
  it "should not allow moves with unknown discs" do
    @hanoi.should_not be_allowed_move(nil, nil)
    @hanoi.should_not be_allowed_move(nil, :c)
    @hanoi.should_not be_allowed_move(:a, nil)
    @hanoi.should_not be_allowed_move(:a, :x)
    @hanoi.should_not be_allowed_move(:x, :a)
  end
  
  it "should be allowed to put a smaller disc on a bigger disc" do
    @hanoi.should be_allowed_move(:a, :b)
    @hanoi.move(:a, :b)

    @hanoi.should be_allowed_move(:b, :a)
    @hanoi.move(:b, :a)    
  end
  

  it "should be allowed to put a smaller disc on a bigger disc" do
    @hanoi.should be_allowed_move(:a, :b)
    @hanoi.move(:a, :b)

    @hanoi.should be_allowed_move(:b, :a)
    @hanoi.move(:b, :a)    
  end

  it "should not be allowed to put a bigger disc on a smaller disc" do
    @hanoi.should be_allowed_move(:a, :b)
    @hanoi.move(:a, :b)
    
    # es ist nicht erlaubt, eine größere auf eine kleinere Scheibe zu legen
    @hanoi.should_not be_allowed_move(:a, :b)
    # es gibt einen Fehler, wenn wir es probieren
    lambda { @hanoi.move(:a, :b) }.should raise_error    
  end

  it "should be finished when all discs are on the last rod" do
    @hanoi.should_not be_finished
    @hanoi.move :a, :c
    @hanoi.move :a, :b
    @hanoi.move :c, :b

    @hanoi.move :a, :c

    @hanoi.move :b, :a
    @hanoi.move :b, :c
    @hanoi.should_not be_finished # wir sind immer noch nicht fertig
    @hanoi.move :a, :c            # letzter Zug
    @hanoi.should be_finished     # fertig!    
  end
  
  it "has unique IDs" do
    RedisHanoi.next_id != RedisHanoi.next_id
  end

  it "has consistent ids for rods" do
    @hanoi.key(:a).should == "hanoi:#{@hanoi.game_id}:a"
    @hanoi.key(:b).should == "hanoi:#{@hanoi.game_id}:b"
    @hanoi.key(:c).should == "hanoi:#{@hanoi.game_id}:c"
  end
  
  it "accepts ids" do  
    @hanoi = RedisHanoi.new(1)
    @hanoi.key(:a).should == "hanoi:1:a"
    @hanoi.key(:b).should == "hanoi:1:b"
    @hanoi.key(:c).should == "hanoi:1:c"
  end

end