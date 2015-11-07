# coding: utf-8

class FakeController1241525 < Nephos::Controller
  DATA = %w(hello wôrld)
  def log_test
    Nephos::Logger.fd = File.open '/tmp/nephos_ftest.log', 'w'
    log DATA
    return {json: DATA}
  end

  def set_cookie
    cookies["name"] = "value"
    return {code: 200}
  end
end

class TestController < Test::Unit::TestCase

  FILE = "/tmp/nephos_ftest.log"

  def test_log_with_one_controller
    # fd = File.open(FILE, "w")
    # Nephos::Logger.fd = fd
    # Nephos.log %w(hello wôrld)
    r = Rack::Request.new({})
    c = FakeController1241525.new(r, {params: []})
    c.log_test
    assert_equal("hello\nwôrld\n", File.read(FILE))
    File.delete FILE
  end

  def test_set_cookies
    router = Nephos::Router.new(silent: true)
    r = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/add_cookie"})
    out = router.execute(r)
    assert_equal "UN_COOKIE_VAUT%3A=UN+BON+MOMENT+%21;path=/", out.header["Set-Cookie"]
  end

end
