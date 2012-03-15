Radium.configure do |rack, config|
  rack.use FrontendServer::AddHeader, 'X-Radium-Developer-API-Key', config.developer_api_key
end