require 'frontend_server'

## Hax
require 'net/http'
require 'net/https'

module Rack
  class ReverseProxy
    def call(env)
      rackreq = Rack::Request.new(env)
      matcher = get_matcher rackreq.fullpath
      return @app.call(env) if matcher.nil?

      uri = matcher.get_uri(rackreq.fullpath,env)
      all_opts = @global_options.dup.merge(matcher.options)
      headers = Rack::Utils::HeaderHash.new
      env.each { |key, value|
        if key =~ /HTTP_(.*)/
          headers[$1] = value
        end
      }
      headers['HOST'] = uri.host if all_opts[:preserve_host]
 
      session = Net::HTTP.new(uri.host, uri.port)
      session.read_timeout=all_opts[:timeout] if all_opts[:timeout]

      session.use_ssl = (uri.scheme == 'https')
      if uri.scheme == 'https' && all_opts[:verify_ssl]
        session.verify_mode = OpenSSL::SSL::VERIFY_PEER
      else
        # DO NOT DO THIS IN PRODUCTION !!!
        session.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      session.start { |http|
        puts "Using these headers: #{headers.inspect}"
        m = rackreq.request_method
        case m
        when "GET", "HEAD", "DELETE", "OPTIONS", "TRACE"
          req = Net::HTTP.const_get(m.capitalize).new(uri.request_uri, headers)
          req.basic_auth all_opts[:username], all_opts[:password] if all_opts[:username] and all_opts[:password]
        when "PUT", "POST"
          req = Net::HTTP.const_get(m.capitalize).new(uri.request_uri, headers)
          req.basic_auth all_opts[:username], all_opts[:password] if all_opts[:username] and all_opts[:password]

          if rackreq.body.respond_to?(:read) && rackreq.body.respond_to?(:rewind)
            body = rackreq.body.read
            req.content_length = body.size
            rackreq.body.rewind
          else
            req.content_length = rackreq.body.size
          end

          req.content_type = rackreq.content_type unless rackreq.content_type.nil?
          req.body_stream = rackreq.body
        else
          raise "method not supported: #{m}"
        end

        body = ''
        res = http.request(req) do |res|
          res.read_body do |segment|
            body << segment
          end
        end

        [res.code, create_response_headers(res), [body]]
      }
    end
  end
end

## HAX
require 'compass'
module Compass::SassExtensions::Functions::GradientSupport

  class ColorStop < Sass::Script::Literal

    def initialize(color, stop = nil)
      self.options = {}
      if color.is_a?(Sass::Script::String) && color.value == 'transparent'
        color = Sass::Script::Color.new([0,0,0,0])
        color.options = {}
      end
      unless Sass::Script::Color === color || Sass::Script::Funcall === color
        raise Sass::SyntaxError, "Expected a color. Got: #{color}"
      end
      if stop && !stop.is_a?(Sass::Script::Number)
        raise Sass::SyntaxError, "Expected a number. Got: #{stop}"
      end
      self.color, self.stop = color, stop
    end

  end

  module Functions

    def color_stops(*args)
      Sass::Script::List.new(args.map do |arg|
        case arg
        when ColorStop
          arg
        when Sass::Script::Color
          ColorStop.new(arg)
        when Sass::Script::List
          ColorStop.new(*arg.value)
        when Sass::Script::String
          ColorStop.new(arg)
        else
          raise Sass::SyntaxError, "Not a valid color stop: #{arg.class.name}: #{arg}"
        end
      end, :comma)
    end
  end
end

class Radium < FrontendServer::Application ; end

class AddCookie 
  def initialize(app, name, value)
    @app, @name, @value = app, name, value
  end

  def call(env)
    status, headers, body = @app.call(env)

    Rack::Utils.set_cookie_header!(headers, @name, @value)

    [status, headers, body]
  end
end

Radium.root = File.dirname __FILE__

$stdout.sync = true
