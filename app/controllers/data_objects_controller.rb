# frozen_string_literal: true

class DataObjectsController < ApplicationController
  def index
    dataset = errors_only? ? DataObject.where(import_status: 0) : DataObject.all
    dataset = dataset.where(import_batch: params[:batch]) if params[:batch]
    @objects = dataset.order_by(updated_at: :desc).page params[:page]
  end

  def show
    @object = DataObject.where(id: params[:id]).first
  end

  private

  def errors_only?
    params.fetch(:errors, 'false') == 'true'
  end
end
