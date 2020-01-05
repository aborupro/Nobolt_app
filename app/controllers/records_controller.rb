class RecordsController < ApplicationController
  before_action :logged_in_user, only: [:create]
  def new       
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
      flash[:info] = "完登記録を保存しました"
      render 'new'
    else
      flash[:danger] = "完登記録を保存できませんでした"
      render 'new'
    end
  end

  def search
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

    respond_to do |format|
      format.html { render 'new' }
      format.js
    end
  end

  private
  def record_params
    params.require(:record).permit(:grade, :problem_id, :strong_point, :picture)
  end
end
