module Checkpoint
  
  class IDCheck
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      if env['rack.session'][:checkpoint_user_id] || env["PATH_INFO"]=~Regexp.new('/sso')
        @app.call(env)
      else
        return [301, {'Location' => '/sso/login', 'Content-Type'=>'text/html'}, "Redirecting to sign in page"] 
      end
    end
    
  end
  
end