class JwtErrorHandler
    def initialize(app)
      @app = app
    end
  
    def call(env)
      begin
        @app.call(env)
      rescue JWT::DecodeError => e
        [
          401,
          { 'Content-Type' => 'application/json' },
          # [ { error: "Invalid or expired token: #{e.message}" }.to_json ]
          [ { error: "Invalid or expired token" }.to_json ]
        ]
      end
    end
  end