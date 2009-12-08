module Checkpoint
  # Authentication Helpers for apps that use Checkpoint
  module Authentication
    def sign_in(user)
      if user.nil?
        session.delete(:checkpoint_user_id)
      else
        session[:checkpoint_user_id] = user.id if user.email_confirmed
      end
    end
    
    def current_user
      session[:checkpoint_user_id].nil? ? nil : ::Checkpoint::User.find(session[:checkpoint_user_id])
    end
    
    def signed_in?
      !current_user.nil?
    end
    
    def absolute_url(suffix = nil)
         port_part = case request.scheme
                     when "http"
                       request.port == 80 ? "" : ":#{request.port}"
                     when "https"
                       request.port == 443 ? "" : ":#{request.port}"
                     end
           "#{request.scheme}://#{request.host}#{port_part}#{suffix}"
    end
  end
end
