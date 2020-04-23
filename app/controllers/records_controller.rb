class RecordsController < ApplicationController
  before_action :logged_in_user, only: [:index, :create, :destroy]
  before_action :correct_user,   only: :destroy
  before_action :set_value,      only: [:new, :search]
  after_action  :set_value,      only: :create

  def index
    @records = Record.paginate(page: params[:page])
  end

  def new
    @record = Record.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @record = current_user.records.build(record_params)
    if params[:record]["gym_name"].present?
      gym_name = Gym.find_by(name: params[:record]["gym_name"])
      @record.gym_id = gym_name.id
    end
    flash.now[:info] = "記録を保存しました" if @record.save
    set_value
    render 'new'
  end

  def destroy
    @record.destroy
    flash[:success] = "記録を削除しました。"
    redirect_to request.referrer || root_url
  end

  def search
    @record = Record.new
    respond_to do |format|
      format.html { render 'new' }
      format.js
    end
  end

  private
  def record_params
    params.require(:record).permit(:grade, :problem_id, :strong_point, :picture)
  end

  def set_value
    if Record.find_by(user_id: current_user.id).present?
      latest_record = Record.find_by(user_id: current_user.id)
      @gym_name = Gym.find(latest_record.gym_id).name
    else
      @gym_name = []
    end
    
  end

  def correct_user
    @record = current_user.records.find_by(id: params[:id])
    redirect_to root_url if @record.nil?
  end
end
