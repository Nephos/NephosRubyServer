# coding: utf-8

class TestNephosServerLogger < Test::Unit::TestCase

  FILE = "/tmp/nephos_test_#{Time.now}.log"

  def test_basic
    fd = File.open(FILE, "w")
    Nephos::Logger.fd = fd
    Nephos::Logger.write "coucou"
    assert_equal("coucou\n", File.read(FILE))
    File.delete FILE

    fd = File.open(FILE, "w")
    Nephos::Logger.fd = fd
    Nephos::Logger.write %w(hello world)
    assert_equal("hello\nworld\n", File.read(FILE))
    File.delete FILE
  end

  def test_basic_shortcut
    fd = File.open(FILE, "w")
    Nephos::Logger.fd = fd
    Nephos.log %w(hello world)
    assert_equal("hello\nworld\n", File.read(FILE))
    File.delete FILE
  end

end
