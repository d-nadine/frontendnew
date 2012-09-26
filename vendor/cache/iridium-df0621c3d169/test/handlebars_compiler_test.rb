require 'test_helper'
require 'stringio'

class HandlebarsCompilerTest < MiniTest::Unit::TestCase
  def handlebars_path
    Iridium.vendor_path.join('handlebars.js')
  end

  def source
    File.read handlebars_path
  end

  def compile(template, options = {})
    Iridium::HandlebarsCompiler.new(source, template).compile(options)
  end

  def test_compiles_a_template
    template = <<-handlebars
    <div>{{name}} hello!</div>
    handlebars

    result = compile template

    refute_empty result
  end
end
