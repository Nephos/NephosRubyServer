class TestNephosServerGenerator < Test::Unit::TestCase

  def test_generator_application
    `rm -rf /tmp/nephos-server-test 2> /tmp/null`

    `./bin/nephos-generator --test -a /tmp/nephos-server-test --no-build --no-git`
    assert(Dir.exist? "/tmp/nephos-server-test")
    assert(File.exist? "/tmp/nephos-server-test/Gemfile")
    assert(File.exist? "/tmp/nephos-server-test/routes.rb")
    assert(Dir.exist? "/tmp/nephos-server-test/app")
    gemfile_data = File.read("/tmp/nephos-server-test/Gemfile").split("\n")
    assert(gemfile_data.include? "gem 'nephos'")
    `rm -rf /tmp/nephos-server-test 2> /tmp/null`
  end

  def test_generator_application_with_build
    `rm -rf /tmp/nephos-server-test 2> /tmp/null`

    `./bin/nephos-generator --test -a /tmp/nephos-server-test --no-git`
    assert(Dir.exist? "/tmp/nephos-server-test")
    assert(File.exist? "/tmp/nephos-server-test/Gemfile")
    assert(File.exist? "/tmp/nephos-server-test/routes.rb")
    assert(Dir.exist? "/tmp/nephos-server-test/app")
    gemfile_data = File.read("/tmp/nephos-server-test/Gemfile").split("\n")
    assert(gemfile_data.include? "gem 'nephos'")

    # if connected to internet only
    assert(File.exist? "/tmp/nephos-server-test/Gemfile.lock")
    gemfile_lock_data = File.read("/tmp/nephos-server-test/Gemfile.lock").split
    assert(gemfile_lock_data.include? "nephos")
    assert(gemfile_lock_data.include? "nephos-server")

    `rm -rf /tmp/nephos-server-test 2> /tmp/null`
  end

  def test_generator_controller
    `rm -f app/test_controller.rb`

    `./bin/nephos-generator --test -c test`
    assert File.exist? "app/test_controller.rb"
    assert_equal "class TestController < Nephos::Controller", File.read("app/test_controller.rb").split("\n").first
    `rm -f app/test_controller.rb`

    `./bin/nephos-generator -c test --test`
    assert File.exist? "app/test_controller.rb"
    assert_equal "class TestController < Nephos::Controller", File.read("app/test_controller.rb").split("\n").first
    `rm -f app/test_controller.rb`

    `./bin/nephos-generator -c testController --test`
    assert File.exist? "app/test_controller.rb"
    assert_equal "class TestController < Nephos::Controller", File.read("app/test_controller.rb").split("\n").first
    `rm -f app/test_controller.rb`
  end

  # test simple and rm
  def test_generator_route1
    s1 = File.read("routes.rb")
    `./bin/nephos-generator --test -r get test ctr#mth`
    s2 = File.read("routes.rb")
    `./bin/nephos-generator --test -r get test ctr#mth --rm`
    s3 = File.read("routes.rb")
    assert_equal s1, s3
    assert_not_equal s1, s2
  end

  # test if ctr#mth == ctr mth
  def test_generator_route2
    s1 = File.read("routes.rb")
    `./bin/nephos-generator --test -r get test ctr#mth`
    s2 = File.read("routes.rb")
    `./bin/nephos-generator --test -r get test ctr mth`
    s3 = File.read("routes.rb")
    `./bin/nephos-generator --test -r get test ctr mth --rm`
    s4 = File.read("routes.rb")
    assert_equal s2, s3
    assert_equal s1, s4
  end

end
