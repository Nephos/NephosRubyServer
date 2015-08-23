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
    {type: 'image/jpeg', content: File.read('controllers/image.jpg')}
  end

  require 'pry'
  def debug
    binding.pry
  end

end
