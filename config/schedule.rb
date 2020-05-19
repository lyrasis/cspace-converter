set :environment, ENV['RAILS_ENV'] ||= 'development'
set :output, File.join('log', 'cron.log')
ENV.each { |k, v| env(k, v) }

every :day, at: '12.30am' do
  rake "cache:refresh"
end
