require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Checkpoint::Consumer" do
  
  it "should verify whether a submitted url represents a valid consumer" do
    consumer = Factory(:consumer)
    Checkpoint::Consumer.allowed?(consumer.url).should be_true
    Checkpoint::Consumer.allowed?("http://notarealcinsumerhost.com").should be_false
  end

end