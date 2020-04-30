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
    @month_choice = (Record.last[:created_at].to_date.beginning_of_month..Date.today)
    .select{|date| date.day == 1 }.map { |item| item.strftime("%Y年%m月")}

    if params[:month].present?
    @target_month = Date.strptime(params[:month], '%Y年%m月')
    @selected_month = params[:month]
    else
    @target_month = Time.current
    @selected_month = Time.current.strftime("%Y年%m月")
    end
    @ranks = Record.unscope(:order)
      .select("user_id
              ,(sum(grade_id) + sum(strong_point)) * 10 as score
              ,RANK () OVER (ORDER BY (sum(grade_id) + sum(strong_point)) * 10 DESC) as rank_number")
      .where(created_at: @target_month.all_month)
      .group("user_id")
      .order("score DESC") 
  end
end
