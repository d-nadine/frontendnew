Radium.configure do |rack, config|
  rack.use FrontendServer::Middleware::AddHeader, 'X-Radium-User-API-Key', config.user_api_key
end
