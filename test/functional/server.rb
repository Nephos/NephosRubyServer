class TestNephosServerBinServer < Test::Unit::TestCase

  def test_daemon
    # WARNING: be sure there is no instance before running theses tests

    # test start and kill
    `./bin/nephos-server --test -d`
    assert_equal 0, $?.exitstatus
    `./bin/nephos-server --test -k`
    assert_equal 0, $?.exitstatus

    # test kill after killed
    `./bin/nephos-server --test -k`
    assert_equal 1, $?.exitstatus
    `./bin/nephos-server --test -k`
    assert_equal 1, $?.exitstatus

    # test start after killed
    `./bin/nephos-server --test -d`
    assert_equal 0, $?.exitstatus

    # test start after started
    `./bin/nephos-server --test -d`
    assert_equal 1, $?.exitstatus
    `./bin/nephos-server --test -d`
    assert_equal 1, $?.exitstatus

    # test kill after started N times
    `./bin/nephos-server --test -k`
    assert_equal 0, $?.exitstatus

    # test kill after started N times and then killed
    `./bin/nephos-server --test -k`
    assert_equal 1, $?.exitstatus
  end

end
