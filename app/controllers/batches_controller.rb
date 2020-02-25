# frozen_string_literal: true

class BatchesController < ApplicationController
  def index
    @objects = Batch.order_by(start: :desc).page params[:page]
  end

  def show
    @objects = CollectionSpaceObject.where(
      batch: params[:batch],
      type: params[:for]
    ).order_by(updated_at: :desc).page params[:page]
  end

  def destroy
    @batch = Batch.find(params[:id])
    @batch.destroy

    redirect_to batches_path
  end

  def types_for_batch
    @types = CollectionSpaceObject.where(
      batch: params[:batch]
    ).order_by(type: 'asc').pluck(:type).uniq
  end
end
