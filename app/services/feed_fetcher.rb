class FeedFetcher
  class_attribute :default_headers

  self.default_headers = {
      "User-Agent" => "Snack/0.1 (https://github.com/knoopx/snack)"
  }

  attr_reader :url, :headers

  def initialize(url, headers = {})
    @url, @headers = url, headers
  end

  def parse
    @parse ||= FeedNormalizer::FeedNormalizer.parse(response.body)
  end

  def response
    @response ||= Nestful.get(url, {}, headers: default_headers.merge(headers))
  end

  def build
    Feed.new(name: parse.title, url: url, etag: response.headers["Etag"], last_update_at: Time.now, entries: build_entries)
  end

  protected

  def build_entries
    parse.entries.map { |entry| build_entry(entry) }
  end

  def build_entry(entry)
    Entry.new(title: entry.title, body: entry.content, url: entry.url, author: entry.author, created_at: entry.date_published)
  end
end
