set :environment, ENV['RAILS_ENV'] ||= 'development'
set :output, "log/cron.log"
ENV.each { |k, v| env(k, v) }

every 1.minute do
  rake "jobs:workoff"
end
