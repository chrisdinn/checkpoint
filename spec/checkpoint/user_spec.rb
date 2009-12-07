require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Checkpoint::User" do
  
  it "should authenticate a user email and password" do
    user = Factory(:user, :password => "cp_password", :password_confirmation => "cp_password")
    Checkpoint::User.authenticate(user.email, "cp_password").should == user
  end
  
end