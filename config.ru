require 'rake-pipeline'
require 'rake-pipeline/middleware'
require "rack/streaming_proxy"

use Rack::StreamingProxy do |request|
  if request.path.start_with?("/api")
    "http://localhost:3000#{request.path.sub("/api", "")}?developer_api_key=26233b7b68290c7c7d4eec03643d0cf3e9b88ba8&user_api_key=90d46b0866c8cb0f8b3cb07f0eb69d2539c21617"
  end
end

use Rake::Pipeline::Middleware, 'Assetfile'
run Rack::Directory.new('public')