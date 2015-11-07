require 'open-uri'

class TestGlobal < Test::Unit::TestCase

  def start_server
    stop_server
    s = `./bin/nephos-server --test -d`
    sleep 1
    s
  end

  def stop_server
    `./bin/nephos-server --test -k`
  end

  def test_simpe_requests_on_app
    start_server
    r = open("http://127.0.0.1:8080/")
    assert_equal "{\"list\":[],\"add\":\"/add\",\"rm\":\"/rm\"}\n", r.read
    assert_equal "application/json; charset=UTF-8", r.meta["content-type"]
    assert_equal "a=b;path=/", r.meta["set-cookie"]
    assert_equal ["200", "OK"], r.status

    r = open("http://127.0.0.1:8080/home")
    assert_equal "{\"list\":[],\"add\":\"/add\",\"rm\":\"/rm\"}\n", r.read
    assert_equal "application/json; charset=UTF-8", r.meta["content-type"]
    assert_equal "a=b;path=/", r.meta["set-cookie"]
    assert_equal ["200", "OK"], r.status

    r = open("http://127.0.0.1:8080/home/")
    assert_equal "{\"list\":[],\"add\":\"/add\",\"rm\":\"/rm\"}\n", r.read
    assert_equal "application/json; charset=UTF-8", r.meta["content-type"]
    assert_equal ["200", "OK"], r.status

    r = open("http://127.0.0.1:8080/hello")
    assert_equal "<html><body><h1>hello world</h1><p>lol</p></body></html>\n", r.read
    assert_equal ["200", "OK"], r.status

    assert_raise do open("http://127.0.0.1:8080/err500") end

    stop_server
  end

end
