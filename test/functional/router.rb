class TestNephosServerAppRouter < Test::Unit::TestCase

  ENV_ALL_VALID_ROUTES = [
    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/home/index"},
    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/home/index/"},
    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/home/index//"},
    {"REQUEST_METHOD"=>"POST", "PATH_INFO"=>"/home/index/add"},
    {"REQUEST_METHOD"=>"POST", "PATH_INFO"=>"/home/index/add/"},
    {"REQUEST_METHOD"=>"POST", "PATH_INFO"=>"/home/index/add//"},
    {"REQUEST_METHOD"=>"PUT", "PATH_INFO"=>"/home/index/rm"},
    {"REQUEST_METHOD"=>"PUT", "PATH_INFO"=>"/home/index/rm/"},
    {"REQUEST_METHOD"=>"PUT", "PATH_INFO"=>"/home/index/rm//"},
    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/home"},
    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/home/"},
    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/home//"},

    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/homes"},
    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/homes/"},
    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/homes//"},

    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/"},
    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/add"},
    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/rm"},
    # {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/debug"},
    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/hello"},

    # {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/image"},
    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/image/image.jpg"},
    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/img/image.jpg"},

    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/get_cookies"},
    {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/add_cookie"},
    # {"REQUEST_METHOD"=>"GET", "PATH_INFO"=>"/err500"},
  ]

  def test_router_all_valid_routes
    router = Nephos::Router.new(silent: true)
    r = []
    ENV_ALL_VALID_ROUTES.each do |env|
      r << router.execute(Rack::Request.new(env))
    end

    r.each_with_index do |rep, idx|
      # puts ENV_ALL_VALID_ROUTES[idx]
      # puts rep
      begin
        assert_equal(200, rep.status)
      rescue => err
        puts rep
        puts err
        raise
      end
    end

  end

end
