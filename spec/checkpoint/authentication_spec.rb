require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class AuthenticationTestApp < Sinatra::Base
  enable :sessions
  helpers ::Checkpoint::Authentication
  use_in_file_templates!
  
  use ::Checkpoint::Sessions::App
  
  get "/" do
    halt(200, haml(:test))
  end
end

describe "Checkpoint::Authentication" do
  include Rack::Test::Methods    
  
  def app
    AuthenticationTestApp
  end
  
  it "should allow requests" do
    get "/"
    last_response.should be_ok
    last_response.body.should include("Test success")
  end
  
  describe "when a user is logged in" do
    before(:each) do
      @user = Factory(:user, :password => "sesh_path", :password_confirmation => "sesh_path")
      post '/sso/login', :email => @user.email, :password => "sesh_path"
    end
  
    it "should find the current user" do
      get "/"
      last_response.body.should include(@user.email)
    end
  
    it "should know if a user is signed in" do
      get "/"
      last_response.body.should include("Signed in")
    end
  end
end

__END__

@@ test
%h1
  Test success
  
%p= current_user.email if current_user

%p= "Signed in" if signed_in?
