require 'haml'
require 'sinatra/base'

module Checkpoint
  module Sessions  
    class App < Sinatra::Base
      enable :sessions
      helpers ::Checkpoint::Authentication
      
      set :views, File.dirname(__FILE__) + '/views'
      
      get '/sso/login' do
        ensure_authenticated
        redirect absolute_url("/")
      end
      
      post '/sso/login' do
        @user = ::Checkpoint::User.authenticate(params['email'], params['password'])
        sign_in(@user)
        ensure_authenticated
        redirect absolute_url("/")
      end
      
      get '/sso/logout' do
        session.clear
        redirect absolute_url("/sso/login")
      end
      
    end
    
  end
end
    