class LikesController < ApplicationController
  before_action :set_record, :logged_in_user

  def create
    @like = current_user.likes.create(record_id: params[:record_id])
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def destroy
    @like = Like.find_by(record_id: params[:record_id], user_id: current_user.id)
    @like.destroy
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  private

  def set_record
    @record = Record.find(params[:record_id])
  end
end
