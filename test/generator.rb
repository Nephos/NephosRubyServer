class TestNephosServerGenerator < Test::Unit::TestCase

  def test_generator_application
    # Dir.chdir("/tmp")
    # name = Time.now.to_i.to_s
    # `nephos-server a #{name}`
  end

  def test_generator_controller
    `rm -f app/test.rb`
    `nephos-generator c test`
    assert File.exists? "app/test.rb"
    assert_equal "class TestController < Nephos::Controller", File.read("app/test.rb").split("\n").first
    `rm -f app/test.rb`
  end

end
