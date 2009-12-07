require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Checkpoint::IDCheck" do
  include Rack::Test::Methods    
  
  def app
    Checkpoint::IDCheck.new(lambda { |env| [200, { 'Content-Type' => 'text/html' }, 'Successful test'] })
  end
    
  it "should redirect request without proper credentials to login" do
    get "/"
    last_response.status.should == 301
    last_response.headers['Location'].should == '/sso/login'
  end
  
  it "should allow request with proper credentials" do
    get "/", {}, {'checkpoint_user_id' => '1'}
    last_response.should be_ok
  end
  
  it "should allow request to log in page" do
    get "/sso/login"
    last_response.should be_ok
  end
  
end
