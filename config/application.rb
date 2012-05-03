Radium.configure do |rack, config|
  rack.use Iridium::Middleware::AddHeader, 'X-Radium-Developer-API-Key', config.developer_api_key
end
