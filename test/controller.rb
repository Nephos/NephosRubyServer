class TestNephosServerController < Test::Unit::TestCase

  def test_initialize_success
    assert Nephos::Controller.new()
    assert Nephos::Controller.new(env={}, {path: [], args: {}}, {params: []})
  end

  def test_initialize_failure
    assert_raise do Nephos::Controller.new({}, {}, {}) end
    assert_raise do Nephos::Controller.new({}, {path: nil}, {}) end
    assert_raise do Nephos::Controller.new({}, {path: []}, {}) end
    assert_raise do Nephos::Controller.new({}, {path: [], args: {}}, {}) end
    assert_raise do Nephos::Controller.new({}, {path: [], args: {}}, {params: nil}) end
    assert_raise do Nephos::Controller.new({}, {path: nil, args: nil}, params: nil) end
    assert_raise do Nephos::Controller.new({}, {path: nil, args: {}}, {params: {}}) end
    assert_raise do Nephos::Controller.new({}, {path: [], args: nil}, {params: {}}) end
  end

end
