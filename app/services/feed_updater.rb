class FeedUpdater
  attr_reader :feed

  def initialize(feed)
    @feed = feed
  end

  def run
    fetcher.parse.entries.each do |entry|
      # TODO: Improved handling of new entries
      if feed.last_update_at.nil? || entry.date_published > feed.last_update_at
        feed.entries.create(title: entry.title, body: entry.content, author: entry.author, created_at: entry.date_published, url: entry.url)
      end
    end
    feed.update_attributes(name: fetcher.parse.title, etag: fetcher.response.headers["Etag"], last_update_at: Time.now)
  end

  def fetcher
    @fetcher ||= FeedFetcher.new(feed.url, "Etag" => feed.etag, "Last-Modified" => feed.last_update_at)
  end
end
