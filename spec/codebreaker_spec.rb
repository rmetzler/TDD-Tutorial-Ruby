module Codebreaker
  class Game
    def initialize(output)
      @output = output
    end
    
    def start
      @output.puts 'Welcome to Codebreaker!'
    end
  end
end

module Codebreaker
  describe Game do
    describe '#start' do
      it 'sends a welcome message' do
        output = double('output') 
        game = Game.new(output)
        
        output.should_receive(:puts).with('Welcome to Codebreaker!')
        
        game.start
        
      end
      
      it 'prompts for the first guess' do
        
      end
    end
  end
end