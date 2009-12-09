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
    
    def ensure_authenticated
      if trust_root = session_return_to || params['return_to']
        if ::Checkpoint::Consumer.allowed?(trust_root)
            if current_user
                redirect "#{trust_root}?id=#{session_user.id}"
            else
                session[:checkpoint_return_to] = trust_root
            end
          else
            forbidden!
          end
        end
      throw(:halt, [401, haml(:login_form)]) unless current_user
    end
    
    def forbidden!
      throw :halt, [403, 'Forbidden']
    end
    
    def current_user
      session[:checkpoint_user_id].nil? ? nil : ::Checkpoint::User.find(session[:checkpoint_user_id])
    end
    
    def signed_in?
      !current_user.nil?
    end
    
    def session_return_to
      session[:checkpoint_return_to]
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
