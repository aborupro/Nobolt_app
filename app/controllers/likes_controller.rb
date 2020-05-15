class LikesController < ApplicationController
  before_action :set_record

  def create
    @like = current_user.likes.create(record_id: params[:record_id])
    # @likes = Like.where(record_id: params[:record_id])
    # @record.reload
    # respond_to do |format|
    #   format.html { redirect_back(fallback_location: root_path)}
    #   format.js
    # end
    # redirect_back(fallback_location: root_path)
    
  end

  def destroy
    @like = Like.find_by(record_id: params[:record_id], user_id: current_user.id)
    @like.destroy
    # @likes = Like.where(record_id: params[:record_id])
    # @record.reload
    # respond_to do |format|
    #   format.html { redirect_back(fallback_location: root_path)}
    #   format.js
    # end
    # redirect_back(fallback_location: root_path)
    
  end

  private

  def set_record
    @record = Record.find(params[:record_id])
  end
end
