class TestNephosServerController < Test::Unit::TestCase

  def test_initialize_success
    assert Nephos::Controller.new()
    assert Nephos::Controller.new(env={}, {path: [], params: {}}, {params: []})
  end

  def test_initialize_failure
    assert_raise do Nephos::Controller.new({}, {}, {}) end
    assert_raise do Nephos::Controller.new({}, {path: nil}, {}) end
    assert_raise do Nephos::Controller.new({}, {path: []}, {}) end
    assert_raise do Nephos::Controller.new({}, {path: [], params: {}}, {}) end
    assert_raise do Nephos::Controller.new({}, {path: [], params: {}}, {params: nil}) end
    assert_raise do Nephos::Controller.new({}, {path: nil, params: nil}, params: nil) end
    assert_raise do Nephos::Controller.new({}, {path: nil, params: {}}, {params: {}}) end
    assert_raise do Nephos::Controller.new({}, {path: [], params: nil}, {params: {}}) end
  end

  def test_controller_params
    c = Nephos::Controller.new(env={}, {path: ["value"], params: {}}, {params: ["param"]})
    assert_equal "value", c.params[:param]
    assert_equal "value", c.params["param"]
  end

end
