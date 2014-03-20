namespace :snack do
  task :fetch => :environment do
    SchedulerWorker.new.perform
  end
end
