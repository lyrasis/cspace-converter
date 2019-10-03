class BatchesController < ApplicationController

  def index
    @objects = Batch.order_by(start: :desc).page params[:page]
  end

  def destroy
    @batch = Batch.find(params[:id])
    @batch.destroy

    redirect_to batches_path
  end

end