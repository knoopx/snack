class Feed < ActiveRecord::Base
  has_many :entries


  def fetch
    FeedUpdater.new(self).run
  end
end
