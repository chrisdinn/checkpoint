module Checkpoint
  class User < ActiveRecord::Base
    include Clearance::User
  end
end
