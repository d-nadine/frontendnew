class Radium < Iridium::Application
  # Stub out an authenticated user so we can develop.
  # You can change the api key by updating config/settings.yml
  middleware.add_cookie 'user_api_key', settings.user_api_key
end
