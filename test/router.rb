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

  def test_init_router
    r1= Nephos::Router.new
    r2= Nephos::Router.new({})
    r3= Nephos::Router.new({silent: false})
    r4= Nephos::Router.new({silent: true})
    assert r1
    assert_equal(false, r1.instance_variable_get(:@silent))
    assert r2
    assert_equal(false, r2.instance_variable_get(:@silent))
    assert r3
    assert_equal(false, r3.instance_variable_get(:@silent))
    assert r4
    assert_equal(true, r4.instance_variable_get(:@silent))
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
    assert "/".match(first[:match])
    assert "//".match(first[:match])
    assert "///".match(first[:match])

    reset_routes!
    post url: "/", controller: "TestController", method: "method", silent: true
    assert_equal "/", first[:url]
    assert_equal "POST", first[:verb]
    assert_equal "TestController", first[:controller]
    assert_equal "method", first[:method]
    assert "/".match(first[:match])
    assert "//".match(first[:match])
    assert "///".match(first[:match])

    reset_routes!
    put url: "/", controller: "TestController", method: "method", silent: true
    assert_equal "/", first[:url]
    assert_equal "PUT", first[:verb]
    assert_equal "TestController", first[:controller]
    assert_equal "method", first[:method]
    assert "/".match(first[:match])
    assert "//".match(first[:match])
    assert "///".match(first[:match])
  end

  def test_valid_routes_params
    reset_routes!
    get url: "/:what", controller: "TestController", method: "method", silent: true
    assert_equal "/:what", first[:url]
    assert !"/".match(first[:match])
    assert !"//".match(first[:match])
    assert !"///".match(first[:match])
    assert "/data".match(first[:match])
    assert "/111".match(first[:match])
    assert "/--_--".match(first[:match])
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
    assert !"/JOME/data".match(first[:match])
    assert !"/1".match(first[:match])
    assert !"/home".match(first[:match])
    assert "/home/data".match(first[:match])
    assert "/home/1".match(first[:match])
  end

  def test_valid_resources_params2
    reset_routes!
    resource "/:id" do
      get url: "/show", controller: "TestController", method: "method", silent: true
    end
    assert_equal "/:id/show", first[:url]
    assert !"/".match(first[:match])
    assert !"/x".match(first[:match])
    assert !"/xx".match(first[:match])
    assert !"//1".match(first[:match])
    assert !"/x/1".match(first[:match])
    assert !"/1/x".match(first[:match])
    assert !"/x//1".match(first[:match])
    assert "/1/show".match(first[:match])
    assert "/show/show".match(first[:match])
    assert "/1//show".match(first[:match])
  end

  REQ_GET_INDEX_ROOTx2 = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"//index"})
  REQ_GET_INDEX = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/index"})
  REQ_POST_INDEX = Rack::Request.new({"REQUEST_METHOD"=>"POST", "PATH_INFO"=>"/index"})
  REQ_PUT_INDEX = Rack::Request.new({"REQUEST_METHOD"=>"PUT", "PATH_INFO"=>"/index"})
  REQ_GET_INDEXX = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/indexx"})
  REQ_GET_INDE = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/inde"})

  def test_routing_matching_simple
    reset_routes!
    get url: "/index", controller: "TestController", method: "method", silent: true
    post url: "/index", controller: "TestController", method: "method", silent: true
    assert(Nephos::Router.new.find_route(REQ_GET_INDEX_ROOTx2))
    assert(Nephos::Router.new.find_route(REQ_GET_INDEX))
    assert(Nephos::Router.new.find_route(REQ_POST_INDEX))
    assert(!Nephos::Router.new.find_route(REQ_PUT_INDEX))
    assert(!Nephos::Router.new.find_route(REQ_GET_INDEXX))
    assert(!Nephos::Router.new.find_route(REQ_GET_INDE))
  end

  REQ_GET_ID_INDEX = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/id/index"})
  REQ_GET_XXX_INDEX = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/XXX/index"})
  REQ_GET_ID = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/id"})
  REQ_GET_XXX = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/XXX"})
  REQ_GET_INDEX_ID = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/index/id"})

  def test_routing_matching_simple_with_arguments1
    reset_routes!
    get url: "/:id", controller: "TestController", method: "method1", silent: true
    get url: "/:id/index", controller: "TestController", method: "method2", silent: true
    assert(Nephos::Router.new.find_route(REQ_GET_ID_INDEX))
    assert(Nephos::Router.new.find_route(REQ_GET_XXX_INDEX))
    assert(Nephos::Router.new.find_route(REQ_GET_ID))
    assert(Nephos::Router.new.find_route(REQ_GET_XXX))
    assert(!Nephos::Router.new.find_route(REQ_GET_INDEX_ID))
  end

  REQ_GET_IDX_INDEX = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/idx/index"})
  REQ_GET_XXX_INDEX = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/XXX/index"})
  REQ_GET_ID = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/id"})
  REQ_GET_XXX = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/XXX"})

  REQ_GET_INDEX_ID = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/index/id"})
  REQ_GET_INDEX_XXX = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/index/XXX"})
  REQ_POST_INDEX_XXX_INDEX = Rack::Request.new({"REQUEST_METHOD"=>"POST", "PATH_INFO"=>"/index/XXX/index"})

  REQ_GET_INDEX_XXX_INDEX = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/index/XXX/index"})
  REQ_POST_INDEX_XXX_ID = Rack::Request.new({"REQUEST_METHOD"=>"POST", "PATH_INFO"=>"/index/XXX/id"})
  REQ_POST_INDEX_XXX_XXX = Rack::Request.new({"REQUEST_METHOD"=>"POST", "PATH_INFO"=>"/index/XXX/XXX"})

  def test_routing_matching_simple_with_arguments2
    reset_routes!
    get url: "/index", controller: "TestController", method: "method1", silent: true
    get url: "/index/:id", controller: "TestController", method: "method1", silent: true
    post url: "/index/:id/index", controller: "TestController", method: "method2", silent: true

    assert(!Nephos::Router.new.find_route(REQ_GET_IDX_INDEX))
    assert(!Nephos::Router.new.find_route(REQ_GET_XXX_INDEX))
    assert(!Nephos::Router.new.find_route(REQ_GET_ID))
    assert(!Nephos::Router.new.find_route(REQ_GET_XXX))

    assert(Nephos::Router.new.find_route(REQ_GET_INDEX_ID))
    assert(Nephos::Router.new.find_route(REQ_GET_INDEX_XXX))
    assert(Nephos::Router.new.find_route(REQ_POST_INDEX_XXX_INDEX))

    assert(!Nephos::Router.new.find_route(REQ_GET_INDEX_XXX_INDEX))
    assert(!Nephos::Router.new.find_route(REQ_POST_INDEX_XXX_ID))
    assert(!Nephos::Router.new.find_route(REQ_POST_INDEX_XXX_XXX))
  end

  def test_routing_extension
    reset_routes!
    get url: "/index", controller: "TestController", method: "method1", silent: true
    get url: "/indexno", controller: "TestController", method: "method1", silent: true, postfix: false
    ok1 = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/index"})
    ok2 = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/index.html"})
    ok3 = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/index.json"})
    ok4 = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/index.xhr"})
    ok5 = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/indexno"})
    ko1 = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/index/html"})
    ko2 = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/indexno.html"})
    ko3 = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/indexno.json"})
    ko4 = Rack::Request.new({"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/indexno.xhr"})
    assert(Nephos::Router.new.find_route(ok1))
    assert(Nephos::Router.new.find_route(ok2))
    assert(Nephos::Router.new.find_route(ok3))
    assert(Nephos::Router.new.find_route(ok4))
    assert(Nephos::Router.new.find_route(ok5))
    assert(!Nephos::Router.new.find_route(ko1))
    assert(!Nephos::Router.new.find_route(ko2))
    assert(!Nephos::Router.new.find_route(ko3))
    assert(!Nephos::Router.new.find_route(ko4))
  end

  def test_routing_eze_router
    reset_routes!
    get url: "/index", controller: "TestController", method: "method1", silent: true
    get url: "/index", to: "TestController#method1", method: "method1", silent: true
    assert_equal Nephos::Router::ROUTES[0], Nephos::Router::ROUTES[1]
  end

  def test_routing_multiple_url
    reset_routes!
    get url: ["/index"], controller: "TestController", method: "method1", silent: true
    get url: "/index", controller: "TestController", method: "method1", silent: true
    reset_routes!
    get url: ["/index", "/index"], controller: "TestController", method: "method1"
    get url: ["/index", "/index"], controller: "TestController", method: "method1"
    assert_equal Nephos::Router::ROUTES[0], Nephos::Router::ROUTES[1]
    assert_equal Nephos::Router::ROUTES[1], Nephos::Router::ROUTES[2]
    assert_equal Nephos::Router::ROUTES[2], Nephos::Router::ROUTES[3]
    reset_routes!
    get url: ["/index", "/me", "/other"], controller: "TestController", method: "method1"
    assert_equal 3, Nephos::Router::ROUTES.size
  end

end
