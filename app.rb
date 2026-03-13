require 'sinatra'
require_relative 'scout_roster'

get '/' do
  erb :index
end
get '/scout' do
    @scouted_players_data = run_scout_and_media
    erb :results
  end