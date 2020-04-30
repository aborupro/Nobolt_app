class RankingsController < ApplicationController
  def rank
    set_value  
  end

  def select
    set_value
    respond_to do |format|
      format.html { render 'rank' }
      format.js
    end
  end

  private

  def set_value
    all_term = "全期間"
    all_gym = "すべて"

    @month_choice = [all_term] + (Record.last[:created_at].to_date.beginning_of_month..Date.today)
    .select{|date| date.day == 1 }.map { |item| item.strftime("%Y年%m月")}.reverse
    
    @gym_choice = [all_gym] + Gym.pluck("name")

    if params[:month].present?
      if params[:month] != "全期間"
        @target_month = Date.strptime(params[:month], '%Y年%m月').all_month
      else
        @target_month = Record.last[:created_at].to_date.beginning_of_month..Date.today
      end
    else
      @target_month = Time.current.all_month
      @selected_month = Time.current.strftime("%Y年%m月")
    end

    if params[:gym].present? && params[:gym] != "すべて"
      @target_gym = Gym.find_by(name: params[:gym]).id
    else
      @target_gym = Gym.pluck("id")
      @selected_gym = all_gym
    end

    @ranks = Record.unscope(:order)
                   .select("user_id
                           ,(sum(grade_id) + sum(strong_point)) * 10 as score
                           ,RANK () OVER (ORDER BY (sum(grade_id) + sum(strong_point)) * 10 DESC) as rank_number")
                   .where(created_at: @target_month).where(gym_id: @target_gym)
                   .group("user_id")
                   .order("score DESC") 
  end
end
