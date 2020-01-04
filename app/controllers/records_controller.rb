class RecordsController < ApplicationController
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
    @gym = Gym.new(gym_params)
    if @gym.save
      flash[:info] = "#{@gym.name} を保存しました"
      redirect_to users_url
    else
      flash[:danger] = "#{@gym.name} を保存できませんでした"
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
      format.html
      format.js
    end
    render 'new'
  end
end
