# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require './sinatra/hangman_helpers'

enable :sessions

get '/' do
  set_game
  erb :index
end

get '/game' do
  erb :game
end

post '/game' do
  update_game(params[:guess].upcase)
  redirect '/win' if win?
  redirect '/lose' if lose?
  erb :game
end

get '/win' do
  erb :win
end

get '/lose' do
  erb :lose
end