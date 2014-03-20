class Entry < ActiveRecord::Base
  belongs_to :feed

  before_create do
    #if readability = ReadabilityParser.parse(self.url)
    #  self.title = readability.title
    #  self.author = readability.author
    #  self.body = readability.content
    #  self.excerpt = readability.excerpt
    #end
    self.excerpt ||= document.search('//text()').map(&:text).join(" ")
    true
  end

  def document
    @document ||= Nokogiri::HTML(self.body)
  end
end
