class TestNephosServerController < Test::Unit::TestCase

  def test_initialize
    assert Nephos::Controller.new()
    assert Nephos::Controller.new(env={}, {path: [], args: {}}, {params: []})
    assert_raise do Nephos::Controller.new({}, {}, {}) end
  end

end
