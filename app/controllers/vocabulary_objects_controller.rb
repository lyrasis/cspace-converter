class VocabularyObjectsController < ApplicationController
  include RemoteActionable

  def index
    @objects = CollectionSpaceObject.where(category: "Vocabulary")
      .order_by(:updated_at => 'desc')
      .page params[:page]
  end

  def show
    @object = CollectionSpaceObject.where(category: "Vocabulary").where(id: params[:id]).first
  end

  # remote actions (concerns/remote_actionable)

end
