class Hanoi

  def initialize
    @rods = {
      :a => [0, 1, 2],
      :b => [],
      :c => [],
    }
  end
  
  def rod(p)
    @rods[p]
  end
  
  def allowed_move?(from, to)
    return false if rod(from).empty?
    return true  if rod(to).empty?
    rod(to).last < rod(from).last
  end
  
  def move(from, to)
    raise Exception.new unless allowed_move?(from, to)
    disc = rod(from).pop
    rod(to).push disc
  end

  def finished?
    rod(:a).empty? && rod(:b).empty? && ! rod(:c).empty?
  end  
  
end

describe Hanoi do
  
  before(:each) do
    @hanoi = Hanoi.new
  end

  it "is possible to start Hanoi" do
    Hanoi.new
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

end