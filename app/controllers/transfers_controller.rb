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
      start: Time.now,
      total: CollectionSpaceObject.where(type: type, batch: batch).count
    )

    if Lookup.async?
      TransferJob.perform_later(action, type, batch, key)
    else
      TransferJob.perform_now(action, type, batch, key)
    end
    flash[:notice] = "Transfer job running. Check back periodically for results."
    redirect_to batches_path
  end

end
