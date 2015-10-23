# coding: utf-8

class FakeController1241525 < Nephos::Controller
  DATA = %w(hello wôrld)
  def log_test
    Logger.fd = File.open '/tmp/nephos_ftest.log', 'w'
    log DATA
    return {json: DATA}
  end
end

class TestController < Test::Unit::TestCase

  FILE = "/tmp/nephos_ftest.log"

  def test_log_with_one_controller
    # fd = File.open(FILE, "w")
    # Nephos::Logger.fd = fd
    # Nephos.log %w(hello wôrld)
    r = Rack::Request.new {}
    c = FakeController1241525.new {}, {params: []}
    c.log_test
    assert_equal("hello\nwôrld\n", File.read(FILE))
    File.delete FILE
  end

end
