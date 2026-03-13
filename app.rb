require 'sinatra'
require_relative 'scout_roster'

get '/' do
  erb :index
end
get '/scout' do
    run_scout_and_media
    "Scouting process complete. Check the scouting_reports folder and the social_media_reports folder for the new files."
end