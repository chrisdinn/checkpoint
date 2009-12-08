module Checkpoint
  class Consumer < ActiveRecord::Base
    def self.allowed?(host)
      !find_by_url(host).nil?
    end
  end
end
