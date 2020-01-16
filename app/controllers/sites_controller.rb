class SitesController < ApplicationController
  include RemoteActionable

  def index; end

  def connection; end

  def nuke
    CollectionSpace::Tools::Nuke.everything!
    reset_cache
    flash[:notice] = 'Database nuked, all records deleted!'
    redirect_to root_path
  end

  def recache
    reset_cache
    flash[:notice] = 'Refreshing cache.'
    redirect_to cache_path
  end
end
