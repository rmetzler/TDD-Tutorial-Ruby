require 'spec_helper'
require 'json'

set :environment, :test
 
describe "Hanoi Webservice Test" do
  include Rack::Test::Methods
 
  def app
    @app ||= Sinatra::Application
  end
 
  # Do a root test
  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end
  
  it "should create a new Hanoi Game and redirect to it" do
    post '/hanoi/'
    follow_redirect!
    
    last_request.url.should match /hanoi\/([0-9]+)$/
    last_response.should be_ok
    
    #puts last_response.body
    hanoi = JSON.parse last_response.body
    
    hanoi['a'].should_not be_empty
    hanoi['b'].should be_empty
    hanoi['c'].should be_empty
    hanoi['finish'].should be_false
    
    id_from_url = /hanoi\/([0-9]+)$/.match(last_request.url)[1]
    hanoi['id'].should eq id_from_url
  end

  it "should move a disk from a to b" do
    post '/hanoi/'
    follow_redirect!
    id_from_start_url = /hanoi\/([0-9]+)$/.match(last_request.url)[1]

    post "#{last_request.url}/move", {:from => "a", :to => "b", }
    follow_redirect!
    id_from_move_url = /hanoi\/([0-9]+)$/.match(last_request.url)[1]

    hanoi = JSON.parse last_response.body
    
    hanoi['a'].should_not be_empty
    hanoi['b'].should_not be_empty
    hanoi['c'].should be_empty
    hanoi['finish'].should be_false
    
    hanoi['id'].should eq id_from_start_url
    hanoi['id'].should eq id_from_move_url
  end
  
  it "should move a disk from a to c" do
    post '/hanoi/'
    follow_redirect!

    post "#{last_request.url}/move", {:from => "a", :to => "c", }
    follow_redirect!

    hanoi = JSON.parse last_response.body
    
    hanoi['a'].should_not be_empty
    hanoi['b'].should be_empty
    hanoi['c'].should_not be_empty
    hanoi['finish'].should be_false
    
  end
  
  it "should return a 403 when move is not allowed" do
    post '/hanoi/'
    follow_redirect!
    
    move_url = "#{last_request.url}/move"

    post move_url, {:from => "b", :to => "c", }
    last_response.status.should eq 403

    post move_url, {:from => "a", }
    last_response.status.should eq 403

    post move_url, {:from => "b", }
    last_response.status.should eq 403

    post move_url, {:to => "c", }
    last_response.status.should eq 403

    post move_url
    last_response.status.should eq 403
  end
    
end