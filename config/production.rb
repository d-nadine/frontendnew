Radium.configure do |rack, config|
  rack.use Rack::Auth::Basic do |username, password|
    password == ENV['WEB_PASSWORD']
  end
end
