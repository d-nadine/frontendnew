Radium.configure do |rack, config|
  rack.use AddCookie, 'user_api_key', config.user_api_key
end
