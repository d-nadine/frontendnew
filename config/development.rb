Radium.configure do |rack, config|
  rack.use FrontendServer::AddHeader, 'X-Radium-User-API-Key', config.user_api_key
end