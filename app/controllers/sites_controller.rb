class SitesController < ApplicationController

  def index
  end

  def connection
  end

  def nuke
    CollectionSpace::Tools::Nuke.everything!
    if Lookup.async?
      CacheJob.perform_later
    else
      CacheJob.perform_now
    end
    flash[:notice] = "Database nuked, all records deleted!"
    redirect_to root_path
  end

end
