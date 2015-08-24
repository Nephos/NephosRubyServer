class MainController < Nephos::Controller

  def root
    {
      json: {
        list: $dataset,
        add: '/add',
        rm: '/rm',
      }
    }
  end

  def add_url
    url = arguments["url"]
    if url
      Dataset << url
      return {plain: "#{url} added"}
    else
      return {plain: "url argument required"}
    end
  end

  def rm_url
    url = arguments[:url]
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

  def image
    dir = File.expand_path('controllers/')
    file = File.expand_path(params["image"], dir)
    if not file[0..(dir.size-1)] == dir
      return {status: 500, plain: "invalid path #{params['image']}"}
    elsif not File.exists? file
      return {status: 404, plain: "invalid path #{params['image']}"}
    else
      return {type: 'image/jpeg', content: File.read(file)}
    end
  end

  require 'pry'
  def debug
    binding.pry
  end

end
