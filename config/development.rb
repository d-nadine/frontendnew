Radium.configure do
  middleware.use Iridium::Middleware::AddCookie, 'user_api_key', settings.user_api_key
end
