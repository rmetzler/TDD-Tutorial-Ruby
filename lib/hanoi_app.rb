require 'sinatra'
require 'json'
require File.join(File.dirname(__FILE__), 'redis_hanoi') 

get '/' do
  "Hello World!"
end

post '/hanoi/' do
  # create a new hanoi game and redirect to it
  hanoi = RedisHanoi.new
  redirect "/hanoi/#{hanoi.game_id}"
end

get '/hanoi/:game_id' do
  hanoi = RedisHanoi.new(params[:game_id])
  {:id => hanoi.game_id,
    :a => hanoi.rod(:a),
    :b => hanoi.rod(:b),
    :c => hanoi.rod(:c),
    :finished => hanoi.finished? }.to_json
end

post '/hanoi/:game_id/move' do
  hanoi = RedisHanoi.new(params[:game_id])

  from = params[:from]
  to   = params[:to]

  not_found unless hanoi.allowed_move? from, to
  hanoi.move from, to

  redirect "/hanoi/#{hanoi.game_id}"
end