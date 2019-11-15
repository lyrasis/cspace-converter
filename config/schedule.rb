set :environment, ENV['RAILS_ENV'] ||= 'development'
set :output, File.join('log', 'cron.log')
ENV.each { |k, v| env(k, v) }

every 5.minutes do
  rake "cache:refresh"
end
