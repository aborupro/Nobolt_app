class LikesController < ApplicationController
  before_action :set_record

  def create
    @like = current_user.likes.create(record_id: params[:record_id])
  end

  def destroy
    @like = Like.find_by(record_id: params[:record_id], user_id: current_user.id)
    @like.destroy
  end

  private

  def set_record
    @record = Record.find(params[:record_id])
  end
end
