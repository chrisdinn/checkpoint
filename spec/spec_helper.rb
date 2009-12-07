$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'checkpoint'

ActiveRecord::Base.establish_connection :adapter => "mysql",
  :encoding => "utf8",
  :reconnect => false,
  :database => "galileo_test",
  :pool => 5,
  :username => "root",
  :password => ""

require 'spec'
require 'spec/autorun'
require 'rack/test'
require 'factory_girl'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

Factory.define :user, :class => Checkpoint::User do |user|
  user.email                 { Factory.next :email }
  user.password              { "password" }
  user.password_confirmation { "password" }
  user.email_confirmed       { true }
end

Factory.define :unconfirmed_user, :class => Checkpoint::User do |user|
  user.email                 { Factory.next :email }
  user.password              { "password" }
  user.password_confirmation { "password" }
  user.email_confirmed       { false }
end

Factory.sequence :email do |n|
  "checkpoint_user_#{n}@example.com"
end

Spec::Runner.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean
  end
end
