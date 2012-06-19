Radium.configure do
  middleware.add_header 'X-Radium-Developer-API-Key', '26233b7b68290c7c7d4eec03643d0cf3e9b88ba8', :url => /^\/api/

  config.proxy '/api', 'http://api.radiumcrm.com'
end
