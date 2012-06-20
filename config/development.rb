Radium.configure do
  middleware.add_cookie 'user_api_key', settings.user_api_key
end
