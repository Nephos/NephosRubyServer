class TestController < Nephos::Controller
  def method
    {plain: "test"}
  end
  def method1
    {plain: "test1"}
  end
  def method2
    {plain: "test2"}
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
    assert_equal /^\/[^\/]+$/, first[:match]
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
    assert_equal /^\/home\/[^\/]+$/, first[:match]
  end

  def test_valid_resources_params2
    reset_routes!
    resource "/:id" do
      get url: "/show", controller: "TestController", method: "method", silent: true
    end
    assert_equal "/:id/show", first[:url]
    assert_equal /^\/[^\/]+\/show$/, first[:match]
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

  def test_routing_matching_simple_with_arguments1
    reset_routes!
    get url: "/:id", controller: "TestController", method: "method1", silent: true
    get url: "/:id/index", controller: "TestController", method: "method2", silent: true
    assert(Nephos::Router::parse_path(["id", "index"], "GET"))
    assert(Nephos::Router::parse_path(["XXX", "index"], "GET"))
    assert(Nephos::Router::parse_path(["id"], "GET"))
    assert(Nephos::Router::parse_path(["XXX"], "GET"))
    assert(Nephos::Router::parse_path(["index", "id"], "GET") == nil)
  end

  def test_routing_matching_simple_with_arguments2
    reset_routes!
    get url: "/index", controller: "TestController", method: "method1", silent: true
    get url: "/index/:id", controller: "TestController", method: "method1", silent: true
    post url: "/index/:id/index", controller: "TestController", method: "method2", silent: true
    assert(Nephos::Router::parse_path(["id", "index"], "GET") == nil)
    assert(Nephos::Router::parse_path(["XXX", "index"], "GET") == nil)
    assert(Nephos::Router::parse_path(["id"], "GET") == nil)
    assert(Nephos::Router::parse_path(["XXX"], "GET") == nil)
    assert(Nephos::Router::parse_path(["index", "id"], "GET"))
    assert(Nephos::Router::parse_path(["index", "XXX"], "GET"))
    assert(Nephos::Router::parse_path(["index", "XXX", "index"], "POST"))
    assert(Nephos::Router::parse_path(["index", "XXX", "index"], "GET") == nil)
    assert(Nephos::Router::parse_path(["index", "XXX", "id"], "POST") == nil)
    assert(Nephos::Router::parse_path(["index", "XXX", "XXX"], "POST") == nil)
  end

end
