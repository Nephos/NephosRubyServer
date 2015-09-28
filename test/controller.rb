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

end
