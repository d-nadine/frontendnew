require 'test_helper'

class JsLintingTest < MiniTest::Unit::TestCase
  def invoke(*args)
    stdout, stderr, status = nil

    stdout, stderr = capture_io do
      Dir.chdir Iridium.application.root do
        status = Iridium::Commands::JSLint.start(args)
      end
    end

    return status, stdout, stderr
  end

  def bad_file
    "foo = 'bar'"
  end

  def good_file
    Iridium::JSLint.source
  end

  def test_pukes_on_bad_files
    result, stdout, stderr = invoke "app/missing_file.js"

    assert_equal 2, result
    assert_includes stderr, "app/missing_file.js"
  end

  def test_returns_success_full_when_file_is_good
    create_file "app/javascripts/app.js", good_file

    result, stdout, stderr = invoke "app/javascripts/app.js"

    assert_equal 0, result
  end

  def test_returns_unsuccessfully_when_file_has_errors
    create_file "app/javascripts/app.js", bad_file

    result, stdout, stderr = invoke "app/javascripts/app.js"

    assert_equal 1, result
    assert_includes stdout, "ERROR: 'foo' was used before it was defined."
    assert_includes stdout, "ERROR: Expected ';' and instead saw '(end)'."
    assert_includes stdout, "2 Error(s)"
  end

  def test_accepts_multiple_files
    create_file "app/javascripts/file1.js", good_file
    create_file "app/javascripts/file2.js", good_file

    result, stdout, stderr = invoke "app/javascripts/file1.js", "app/javascripts/file2.js"

    assert_equal 0, result
    assert_includes stdout, "2 File(s)"
  end

  def test_defaults_to_all_js_files
    create_file "app/javascripts/file1.js", good_file
    create_file "app/javascripts/file2.js", good_file

    result, stdout, stderr = invoke

    assert_equal 0, result
    assert_includes stdout, "2 File(s)"
  end

  def test_expand_directory_arguments
    create_file "app/javascripts/file1.js", good_file
    create_file "app/javascripts/file2.js", good_file

    result, stdout, stderr = invoke "app/javascripts"

    assert_equal 0, result
    assert_includes stdout, "2 File(s)"
  end

  def test_pukes_on_non_javascript
    create_file "app/javascripts/file1.rb", good_file

    result, stdout, stderr = invoke "app/javascripts/file1.rb"

    assert_equal 2, result
    assert_includes stderr, "app/javascripts/file1.rb"
  end
end
