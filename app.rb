require 'sinatra'
require_relative 'scout_roster'

get '/' do
  erb :index
end