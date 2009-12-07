module Checkpoint
  # Authentication Helpers for apps that use Checkpoint
  module Authentication
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
