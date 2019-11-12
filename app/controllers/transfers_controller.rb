class TransfersController < ApplicationController

  def new
    # form
  end

  def create
    action = params[:remote_action]
    type   = params[:type]
    batch  = params[:batch]

    key = SecureRandom.uuid
    Batch.create(
      key: key,
      category: 'transfer',
      type: action,
      for: type,
      name: batch,
      start: Time.now
    )

    TransferJob.perform_later(action, type, batch, key)
    flash[:notice] = "Transfer job running. Check back periodically for results."
    redirect_to batches_path
  end

end
