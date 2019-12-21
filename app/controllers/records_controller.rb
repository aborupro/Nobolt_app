class RecordsController < ApplicationController
  def new
    @record = Record.new
  end
  
  def create
    @gym = Gym.new(gym_params)
    if @gym.save
      flash[:info] = "#{@gym.name} を保存しました"
      redirect_to gyms_path
    else
      flash[:danger] = "#{@gym.name} を保存できませんでした"
      render 'new'
    end
  end
end
