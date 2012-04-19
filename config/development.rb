Radium.configure do |rack, config|
  rack.use FrontendServer::Middleware::AddCookie, 'user_api_key', config.user_api_key
end
