class MainController < Nephos::Controller

  before_action :fct_before_all
  before_action :fct_before_root, only: [:root]
  after_action :fct_after_root, only: :root

  def fct_before_all
    # puts "BEFORE ALL"
  end

  def fct_before_root
    # puts "BEFORE"
  end

  def fct_after_root
    # puts "AFTER"
  end

  def root
    # puts "ROOT"
    cookies["a"] = "b"
    cookies.delete("b").to_h
    # puts "Cookies from the root:", cookies
    {
      json: {
        list: $dataset,
        add: '/add',
        rm: '/rm',
      }
    }
  end

  def add_url
    url = params["url"]
    if url
      Dataset << url
      return {plain: "#{url} added"}
    else
      return {plain: "url argument required"}
    end
  end

  def rm_url
    url = params[:url]
    if url
      Dataset.rm url
      return {plain: "#{url} removed"}
    else
      return {plain: "url argument required"}
    end
  end

  def hello
    {html: "<html><body><h1>hello world</h1><p>lol</p></body></html>"}
  end

  AUTH_IMG_EXT = %w(.jpg .jpeg .png .gif)
  def image
    dir = File.expand_path('app/')
    file = File.expand_path(params["image"], dir)
    if not file[0..(dir.size-1)] == dir or not AUTH_IMG_EXT.include?(File.extname(file))
      return {status: 500, content: "invalid path #{params['image']}"}
    elsif not File.exists? file
      return {status: 404, content: "invalid path #{params['image']}"}
    else
      return {type: 'image/jpeg', content: File.read(file)}
    end
  end

  def add_cookie
    cookies["UN_COOKIE_VAUT:"] = "UN BON MOMENT !"
    {plain: "cookie set"}
  end

  def get_cookies
    {json: cookies.to_h}
  end

  # require 'pry'
  def debug
    # binding.pry
    {}
  end

  def err500
    tessssssssss
  end

end
