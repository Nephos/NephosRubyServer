class ReqWithWritableParams < Rack::Request
  def params
    return Hash[@env["REQUEST_URI"].gsub(/.*\?(.+)/, '\1').split('&').map{|d| d.split('=')}]
  end
end

class TestNephosServerController < Test::Unit::TestCase

  def test_initialize
    assert_raise do Nephos::Controller.new() end
    assert_raise do Nephos::Controller.new({}) end
    assert_raise do Nephos::Controller.new({}, {}) end

    r = Rack::Request.new({})
    assert_raise do Nephos::Controller.new() end
    assert_raise do Nephos::Controller.new(r) end
    assert_raise do Nephos::Controller.new(r, {}) end
    assert do Nephos::Controller.new(r, {params: []}) end
  end

  def test_controller_params
    r = ReqWithWritableParams.new({"REQUEST_METHOD"=>"GET",
                                   "PATH_INFO"=>"/index",
                                   "REQUEST_URI"=>"/uri?k=v"})
    c = Nephos::Controller.new(r, {params: []})
    assert_equal "v", c.params[:k]
    assert_equal "v", c.params["k"]
  end

  def test_url_for
    r1 = ReqWithWritableParams.new({"REQUEST_METHOD"=>"GET",
                                    "PATH_INFO"=>"/",
                                    "REQUEST_URI"=>"/",
                                    "HTTP_HOST"=>"localhost:8080",
                                    "rack.url_scheme"=>"http"})
    r2 = ReqWithWritableParams.new({"REQUEST_METHOD"=>"GET",
                                    "PATH_INFO"=>"/index",
                                    "REQUEST_URI"=>"/index?k=v",
                                    "HTTP_HOST"=>"localhost:8081",
                                    "rack.url_scheme"=>"https"})
    c1 = Nephos::Controller.new(r1, {params: []})
    c2 = Nephos::Controller.new(r2, {params: []})
    assert_equal("http://localhost:8080/", c1.url_for(""))
    assert_equal("http://localhost:8080/", c1.url_for("/"))
    assert_equal("http://localhost:8080/sh", c1.url_for("sh"))
    assert_equal("http://localhost:8080/sh/oh", c1.url_for("sh/oh"))
    assert_equal("https://localhost:8081/", c2.url_for(""))
    assert_equal("https://localhost:8081/", c2.url_for("/"))
    assert_equal("https://localhost:8081/sh", c2.url_for("sh"))
    assert_equal("https://localhost:8081/sh/oh", c2.url_for("sh/oh"))
  end

end
