class GymsController < ApplicationController
  def show
    @gym = Gym.find(params[:id])
  end

  def new
    @gym = Gym.new
  end
end
