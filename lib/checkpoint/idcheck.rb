module Checkpoint
  
  class IDCheck
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      if session_exists?(env) || env["PATH_INFO"]=~Regexp.new('/sso')
        @app.call(env)
      else
        return [301, {'Location' => '/sso/login', 'Content-Type'=>'text/html'}, "Redirecting to sign in page"] 
      end
    end
    
    def session_exists?(env)
      env.has_key?('rack.session') && env['rack.session'].has_key?(:checkpoint_user_id)
    end
  end
  
end