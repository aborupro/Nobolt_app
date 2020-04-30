class RankingsController < ApplicationController
  before_action :logged_in_user

  def rank
    set_value
  end

  private

  def set_value
    all_term = "全期間"
    all_gym = "すべてのジム"

    @month_choice = [all_term] + (Record.last[:created_at].to_date.beginning_of_month..Date.today)
    .select{|date| date.day == 1 }.map { |item| item.strftime("%Y年%m月")}.reverse
    
    @gym_choice = [all_gym] + Gym.pluck("name")

    if params[:month].present?
      if params[:month] != all_term
        @target_month = Date.strptime(params[:month], '%Y年%m月').all_month

      else
        @target_month = Record.last[:created_at].to_date.beginning_of_month..Date.today
      end
      @selected_month = params[:month]
    else
      @target_month = Time.current.all_month
      @selected_month = Time.current.strftime("%Y年%m月")
    end

    if params[:gym].present? && params[:gym] != all_gym
      @target_gym = Gym.find_by(name: params[:gym]).id
      @selected_gym = params[:gym]
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
    
    @my_rank = 0
    @ranks.each do |rank|
      if rank.user_id == current_user.id
        @my_rank = rank.rank_number
        break
      end
    end
    @total_user = @ranks.size
    @ranks = @ranks.all.page(params[:page])
  end
end
