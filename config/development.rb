Radium.configure do |rack, config|
  rack.use Iridium::Middleware::AddCookie, 'user_api_key', config.user_api_key
end
