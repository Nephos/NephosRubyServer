class TestController < Nephos::Controller
  def method
    {plain: "test"}
  end
end

class TestNephosServerRouter < Test::Unit::TestCase

  def reset_routes!
    Nephos::Router::ROUTES.clear
  end

  def first
    Nephos::Router::ROUTES.first
  end

  def test_multi_routes
    reset_routes!
    get url: "/a", controller: "TestController", method: "method", silent: true
    get url: "/b", controller: "TestController", method: "method", silent: true
    get url: "/c", controller: "TestController", method: "method", silent: true
    post url: "/a", controller: "TestController", method: "method", silent: true
    post url: "/b", controller: "TestController", method: "method", silent: true
    post url: "/c", controller: "TestController", method: "method", silent: true
    put url: "/a", controller: "TestController", method: "method", silent: true
    put url: "/b", controller: "TestController", method: "method", silent: true
    put url: "/c", controller: "TestController", method: "method", silent: true
    assert_equal 9, Nephos::Router::ROUTES.size
    assert_equal 3, Nephos::Router::ROUTES.select{ |r|
      r[:verb] == "GET"
    }.size
  end

  def test_valid_routes
    reset_routes!
    get url: "/", controller: "TestController", method: "method", silent: true
    assert_equal "/", first[:url]
    assert_equal "GET", first[:verb]
    assert_equal "TestController", first[:controller]
    assert_equal "method", first[:method]
    assert_equal /^\/$/, first[:match]

    reset_routes!
    post url: "/", controller: "TestController", method: "method", silent: true
    assert_equal "/", first[:url]
    assert_equal "POST", first[:verb]
    assert_equal "TestController", first[:controller]
    assert_equal "method", first[:method]
    assert_equal /^\/$/, first[:match]

    reset_routes!
    put url: "/", controller: "TestController", method: "method", silent: true
    assert_equal "/", first[:url]
    assert_equal "PUT", first[:verb]
    assert_equal "TestController", first[:controller]
    assert_equal "method", first[:method]
    assert_equal /^\/$/, first[:match]
  end

  def test_valid_routes_params
    reset_routes!
    get url: "/:what", controller: "TestController", method: "method", silent: true
    assert_equal "/:what", first[:url]
    assert_equal /^\/[[:graph:]]+$/, first[:match]
  end

  def test_valid_resources
    reset_routes!
    resource "/home" do
      assert_equal route_prefix, "/home"
    end
    resource "/home" do
      get url: "/help", controller: "TestController", method: "method", silent: true
    end
    assert_equal "/home/help", first[:url]
  end

  def test_valid_resources_params
    reset_routes!
    resource "/home" do
      get url: "/:what", controller: "TestController", method: "method", silent: true
    end
    assert_equal "/home/:what", first[:url]
    assert_equal /^\/home\/[[:graph:]]+$/, first[:match]
  end

  def test_valid_resources_params2
    reset_routes!
    resource "/:id" do
      get url: "/show", controller: "TestController", method: "method", silent: true
    end
    assert_equal "/:id/show", first[:url]
    assert_equal /^\/[[:graph:]]+\/show$/, first[:match]
  end

  def test_routing_matching_simple
    reset_routes!
    get url: "/index", controller: "TestController", method: "method", silent: true
    post url: "/index", controller: "TestController", method: "method", silent: true
    assert(Nephos::Router::parse_path(["index"], "GET"))
    assert(Nephos::Router::parse_path(["index"], "POST"))
    assert(Nephos::Router::parse_path(["index"], "PUT") == nil)
    assert(Nephos::Router::parse_path(["indexx"], "GET") == nil)
    assert(Nephos::Router::parse_path(["inde"], "GET") == nil)
  end

end
