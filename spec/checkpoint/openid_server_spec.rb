require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class OpenIDServerTestApp < Sinatra::Base
  use ::Checkpoint::Sessions::App
  register ::Checkpoint::OpenIDServer
end

describe "Checkpoint::OpenIDServer" do
  include Rack::Test::Methods    

  def app
    OpenIDServerTestApp
  end
  
  describe "visiting /sso" do
    
    before(:each) do
        @user = Factory(:user)
        @consumer = Factory(:consumer)
        @identity_url = "http://example.org/sso/users/#{@user.id}"
    end
    
    it "should throw a bad request if there aren't any openid params" do
      get '/sso'
      last_response.status.should eql(400)
    end
    
    describe "with openid mode of associate" do
      it "should respond with Diffie Hellman data in kv format" do
        session = OpenID::Consumer::AssociationManager.create_session("DH-SHA1")
        params = {"openid.ns" => 'http://specs.openid.net/auth/2.0',
                   "openid.mode" => "associate",
                   "openid.session_type" => 'DH-SHA1',
                   "openid.assoc_type" => 'HMAC-SHA1',
                   "openid.dh_consumer_public"=> session.get_request['dh_consumer_public']}

        get "/sso", params

        last_response.should be_an_openid_associate_response(session)
      end
    end
      
    describe "with openid mode of checkid_setup" do
      describe "when authenticated" do
        it "should redirect to the consumer app" do
          params = {
              "openid.ns" => "http://specs.openid.net/auth/2.0",
              "openid.mode" => "checkid_setup",
              "openid.return_to" => @consumer.url,
              "openid.identity" => @identity_url,
              "openid.claimed_id" => @identity_url
          }

          login(@user)
          get "/sso", params
          last_response.status.should == 302
          last_response.should be_a_redirect_to_the_consumer(@consumer, @user)
        end

        describe "but attempting to access from an untrusted consumer" do
          it "should cancel the openid request" do
            params = {
              "openid.ns" => "http://specs.openid.net/auth/2.0",
              "openid.mode" => "checkid_setup",
              "openid.return_to" => "http://rogueconsumerapp.com/",
              "openid.identity" => @identity_url,
              "openid.claimed_id" => @identity_url
            }

            login(@user)
            get "/sso", params
            last_response.status.should == 403
          end
        end
      end
    end
  end
end