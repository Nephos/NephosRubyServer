class TestNephosServerGenerator < Test::Unit::TestCase

  def test_generator_application
    # Dir.chdir("/tmp")
    # name = Time.now.to_i.to_s
    # `nephos-server a #{name}`
  end

  def test_generator_controller
    `rm -f app/test.rb`

    `nephos-generator --debug c test`
    assert File.exists? "app/test.rb"
    assert_equal "class TestController < Nephos::Controller", File.read("app/test.rb").split("\n").first
    `rm -f app/test.rb`

    `nephos-generator c test --debug`
    assert File.exists? "app/test.rb"
    assert_equal "class TestController < Nephos::Controller", File.read("app/test.rb").split("\n").first
    `rm -f app/test.rb`
  end

  # test simple and rm
  def test_generator_route1
    s1 = File.read("routes.rb")
    `./bin/nephos-generator --debug r get test ctr#mth`
    s2 = File.read("routes.rb")
    `./bin/nephos-generator --debug r get test ctr#mth --rm`
    s3 = File.read("routes.rb")
    assert_equal s1, s3
    assert_not_equal s1, s2
  end

  # test if ctr#mth == ctr mth
  def test_generator_route2
    s1 = File.read("routes.rb")
    `./bin/nephos-generator --debug r get test ctr#mth`
    s2 = File.read("routes.rb")
    `./bin/nephos-generator --debug r get test ctr mth`
    s3 = File.read("routes.rb")
    `./bin/nephos-generator --debug r get test ctr mth --rm`
    s4 = File.read("routes.rb")
    assert_equal s2, s3
    assert_equal s1, s4
  end

end
