require 'optparse'

module Iridium
  module Commands
    class Test
      class << self
        def start(args = ARGV)
          options = {}

          unless Iridium.application
            begin
              require './application.rb'
            rescue LoadError
              $stderr.puts "Could not find application.rb. Navigate to the root of your Iridium app"
              exit 2
            end
          end

          OptionParser.new do |opts|
            opts.banner = "Usage: PATH [PATH] [options]"

            opts.on "--debug", "Print messages from tests" do
              options[:debug] = true
            end

            opts.on "--dry-run", "Setup and tear down the test suite without executing the tests" do
              options[:dry_run] = true
            end

            opts.on "--seed", "Seed for the random number generator" do |s|
              options[:seed] = s.to_i
            end

            # No argument, shows at tail.  This will print an options summary.
            # Try it and see!
            opts.on_tail("-h", "--help", "Show this message") do
              puts opts
              exit
            end
          end.parse! args

          if args.size == 0
            args = Dir['test/**/*_test.{coffee,js}']
          end

          TestSuite.execute args, options
        end
      end
    end
  end
end
