
class TestNephosServerResponder < Test::Unit::TestCase

  def test_content_type
    assert_equal(
      {'Content-type' => "KIND/TYPE" "; charset=" "CHARSET"},
      Nephos::Responder.content_type("KIND", "TYPE", "CHARSET")
    )
  end

  def test_ct_specific
    p0 = {type: "text/plain"}
    p1 = {type: "/"}
    p2 = {type: "text/"}
    p3 = {type: "/plain"}
    p4 = {type: "textplain"}
    p5 = {type: ""}
    p6 = {type: 1}
    p7 = {type: []}
    p8 = {type: nil}
    p9 = {}
    assert Nephos::Responder.ct_specific(p0)
    assert_raise Nephos::Responder::InvalidContentType do Nephos::Responder.ct_specific(p1) end
    assert_raise Nephos::Responder::InvalidContentType do Nephos::Responder.ct_specific(p2) end
    assert_raise Nephos::Responder::InvalidContentType do Nephos::Responder.ct_specific(p3) end
    assert_raise Nephos::Responder::InvalidContentType do Nephos::Responder.ct_specific(p4) end
    assert_raise Nephos::Responder::InvalidContentType do Nephos::Responder.ct_specific(p5) end
    assert_raise Nephos::Responder::InvalidContentType do Nephos::Responder.ct_specific(p6) end
    assert_raise Nephos::Responder::InvalidContentType do Nephos::Responder.ct_specific(p7) end
    assert_raise Nephos::Responder::InvalidContentType do Nephos::Responder.ct_specific(p8) end
    assert_raise Nephos::Responder::InvalidContentType do Nephos::Responder.ct_specific(p9) end
  end

  def test_set_default_params_status
    p1 = {status: 200}
    p2 = {status: 300}
    p3 = {status: nil}
    p4 = {}
    Nephos::Responder.set_default_params_status(p1)
    Nephos::Responder.set_default_params_status(p2)
    Nephos::Responder.set_default_params_status(p3)
    Nephos::Responder.set_default_params_status(p4)
    assert_equal({status: 200}, p1)
    assert_equal({status: 300}, p2)
    assert_equal({status: 200}, p3)
    assert_equal({status: 200}, p4)
  end

  def test_set_default_params_type_1
    p_ref = {type: Nephos::Responder.ct_specific({type: "text/plain"})}
    p1 = {type: "text/plain"}
    p2 = {type: "text"}
    p3 = {type: "text/plain"}
    Nephos::Responder.set_default_params_type(p1)
    assert_equal p1, p_ref
    assert_raise Nephos::Responder::InvalidContentType do
      Nephos::Responder.set_default_params_type(p2) end
    Nephos::Responder.set_default_params_type(p3)
    assert_equal p_ref, p3
  end

  def test_set_default_params_type_2
    p1 = {plain: "bla"}
    p2 = {html: "bla"}
    p3 = {json: "bla", plain: "bla"}
    p4 = {json: "bla", html: "bla"}
    p5 = {json: "bla"}
    Nephos::Responder.set_default_params_type(p1)
    Nephos::Responder.set_default_params_type(p2)
    Nephos::Responder.set_default_params_type(p3)
    Nephos::Responder.set_default_params_type(p4)
    Nephos::Responder.set_default_params_type(p5)
    plain = Nephos::Responder.ct_specific({type: "text/plain"})
    json = Nephos::Responder.ct_specific({type: "text/javascript"})
    html = Nephos::Responder.ct_specific({type: "text/html"})
    assert_equal plain, p1[:type]
    assert_equal html, p2[:type]
    assert_equal json, p3[:type]
    assert_equal json, p4[:type]
    assert_equal json, p5[:type]
  end

  def test_render_empty
    assert_equal(
      [204, Nephos::Responder.ct_specific({type: "text/plain"}), [""]],
      Nephos::Responder.render(:empty)
    )
  end

end
