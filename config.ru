require 'erb'
require 'yaml'
require 'rack/reverse_proxy'
require 'rack/rewrite'
require 'rake-pipeline'
require 'rake-pipeline/middleware'

class Application
  def self.env=(env)
    @env = env
  end

  def self.env
    @env
  end

  def self.config=(config)
    @config = config.freeze
  end

  def self.config
    @config
  end

  def self.user_api_key
    @config['user_api_key']
  end

  def self.developer_api_key
    @config['developer_api_key']
  end

  def self.server
    @config['server']
  end
end

Application.env = ENV['RACK_ENV'] || 'development'

Application.config = YAML.load(ERB.new(File.read(File.expand_path('../config.yml', __FILE__))).result)[Application.env]

class DeveloperKeyHeader
  def initialize(app)
    @app = app
  end

  def call(env)
    env['HTTP_X_RADIUM_DEVELOPER_API_KEY'] = Application.developer_api_key
    @app.call env
  end
end

class UserKeyHeader
  def initialize(app)
    @app = app
  end

  def call(env)
    env['HTTP_X_RADIUM_USER_API_KEY'] = Application.user_api_key
    @app.call env
  end
end

puts "Starting Application in #{Application.env}..."

use DeveloperKeyHeader

if Application.env == 'development'
  use UserKeyHeader
  use Rake::Pipeline::Middleware, 'Assetfile'
elsif Application.env == 'production'
  use Rack::ETag
  use Rack::Rewrite do
   rewrite '/', '/index.html'
  end
end

use Rack::ReverseProxy do
  reverse_proxy /^\/api(\/.*)$/, "#{Application.server}$1"
end

run Rack::Directory.new('public')
