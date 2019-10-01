namespace :db do
  # bundle exec rake db:nuke
  task :nuke => :environment do |t|
    CollectionSpace::Tools::Nuke.everything!
    Rails.logger.debug "Database nuked!"
  end
end
