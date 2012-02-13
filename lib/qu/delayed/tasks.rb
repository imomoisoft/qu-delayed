namespace :qu do
  namespace :delayed do
    desc "Start a sheduler"
    task :work  => :environment do
      Qu::Delayed::Worker.new.start
    end
  end
end

# Convenience tasks compatibility
task 'resque:scheduler' => 'qu:delayed:work'

# No-op task in case it doesn't already exist
task :environment
