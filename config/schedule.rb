# frozen_string_literal: true

set :environment, ENV['RAILS_ENV'] ||= 'development'
set :output, File.join('log', 'cron.log')
ENV.each { |k, v| env(k, v) }

every ENV.fetch('CSPACE_CONVERTER_CACHE_REFRESH', '0 0 * * *') do
  rake 'cache:refresh'
end
