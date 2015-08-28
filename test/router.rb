class TestController < Nephos::Controller
  def method
    {plain: "test"}
  end
end

class TestNephosServerRouter < Test::Unit::TestCase

  # remove all seeds
  Nephos::Router::ROUTES = []

  def test_valid_routes
    get url: "/", controller: "TestController", method: "method", silent: true
    post url: "/", controller: "TestController", method: "method", silent: true
    put url: "/", controller: "TestController", method: "method", silent: true
  end

end
