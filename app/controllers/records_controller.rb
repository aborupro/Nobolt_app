class RecordsController < ApplicationController
  before_action :logged_in_user, only: [:create]
  before_action :set_value,      only: [:new, :search]
  before_action :correct_user,   only: :destroy

  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    record_gym = Gym.find_by(name: params[:record]["gym_name"])
    @record = current_user.records.build(record_params)
    @record.gym_id = record_gym.id
    if @record.save
      flash[:info] = "記録を保存しました"
    else
      flash[:danger] = "記録を保存できませんでした"
    end
    gyms = Gym.where(prefecture: "#{record_gym.prefecture}")
    @selected_prefecture = record_gym.prefecture
    @gym_name = []
    gyms.each do |gym|
      @gym_name.push(gym.name)
    end
    @gym_name.sort!
    @selected_gym_name = record_gym.name
    @record = Record.new
    render 'new'
  end

  def destroy
    @record.destroy
    flash[:success] = "記録を削除しました。"
    redirect_to request.referrer || root_url
  end

  def search
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
    if params[:prefecture_key]
      gyms = Gym.where(prefecture: "#{params[:prefecture_key]}")
      @selected_prefecture = params[:prefecture_key]
    else
      gyms = Gym.all
      @selected_prefecture = "東京都"
    end

    @gym_name = []
    gyms.each do |gym|
      @gym_name.push(gym.name)
    end
    @gym_name.sort!
    @selected_gym_name ||= ''
    @record = Record.new
  end

  def correct_user
    @record = current_user.records.find_by(id: params[:id])
    redirect_to root_url if @record.nil?
  end
end
