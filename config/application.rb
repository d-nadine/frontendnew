Radium.configure do |rack, config|
  rack.use FrontendServer::Middleware::AddHeader, 'X-Radium-Developer-API-Key', config.developer_api_key
end
