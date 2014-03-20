class FeedDiscoverer
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def feeds
    @feeds ||= Feedbag.find(url)
  end
end
