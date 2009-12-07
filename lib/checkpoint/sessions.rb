require 'haml'
require 'sinatra/base'

module Checkpoint
  module Sessions
    module Helpers
      def login_as(user)
        if user.nil?
          session.delete(:checkpoint_user_id)
        else
          session[:checkpoint_user_id] = user.id
        end
      end
      
      def ensure_authenticated
        throw(:halt, [401, haml(:login_form)]) unless current_user
      end
    end
    
    class App < Sinatra::Base
      enable :sessions
      helpers Helpers
      helpers ::Checkpoint::Authentication
      
      set :views, File.dirname(__FILE__) + '/views'
      
      get '/sso/login' do
        ensure_authenticated
        redirect "/"
      end
      
      post '/sso/login' do
        @user = ::Checkpoint::User.authenticate(params['email'], params['password'])
        login_as(@user)
        ensure_authenticated
        redirect "/"
      end
      
      get '/sso/logout' do
        session.clear
        redirect '/'
      end
      
    end
    
  end
end
    