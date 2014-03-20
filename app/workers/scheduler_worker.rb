class SchedulerWorker
  include SuckerPunch::Job

  def perform
    puts "Refreshing feeds"

    ActiveRecord::Base.connection_pool.with_connection do
      Feed.find_each do |feed|
        FeedUpdaterWorker.new.async.perform(feed)
      end
    end
    after(5.minutes) { perform }
  end
end
