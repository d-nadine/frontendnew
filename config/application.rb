Radium.configure do
  middleware.use Iridium::Middleware::AddHeader, 'X-Radium-Developer-API-Key',
    settings.developer_api_key
end
