class TestNephosServerParams < Test::Unit::TestCase

  def test_basic
    p = Nephos::Params.new
    assert p.empty?
    p[:a] = "1"
    assert_equal p[:a], "1"
    assert_equal p["a"], "1"
    p["a"] = "2"
    assert_equal p[:a], "2"
    assert_equal p["a"], "2"
  end

end
