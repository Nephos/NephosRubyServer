require 'open-uri'

module Dataset

  $dataset = []
  LOCK = Mutex.new

  def self.start
    Thread.new do
      loop do
        $dataset.each do |url|
          print "Open #{url} "
          begin
            open(url)
            puts "SUCCESS"
          rescue => err
            puts "FAILURE #{err.message}"
          end
          sleep 1
        end
      end
    end
  end

  def self.<<(url)
    if not $started
      $started = true
      start
    end
    LOCK.lock
    $dataset << url
    $dataset.uniq!
    LOCK.unlock
  end

  def self.rm(url)
    LOCK.lock
    $dataset.remove url
    LOCK.unlock
  end

end
