class FeedUpdaterWorker
  include SuckerPunch::Job
  workers 6

  def perform(feed)
    ActiveRecord::Base.connection_pool.with_connection do
      FeedUpdater.new(feed).run
    end
  end
end
