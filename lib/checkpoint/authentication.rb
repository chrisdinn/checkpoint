module Checkpoint
  # Authentication Helpers for apps that use Checkpoint
  module Authentication
    def current_user
      session[:checkpoint_user_id].nil? ? nil : ::Checkpoint::User.find(session[:checkpoint_user_id])
    end
    
    def signed_in?
      !current_user.nil?
    end
  end
end
