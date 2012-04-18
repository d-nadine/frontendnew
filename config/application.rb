class InspectorMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new env
    puts req.inspect

    @app.call env
  end
end

Radium.configure do |rack, config|
  rack.use FrontendServer::Middleware::AddHeader, 'X-Radium-Developer-API-Key', config.developer_api_key
  rack.use InspectorMiddleware
end
