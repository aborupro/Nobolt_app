class RankingsController < ApplicationController
  def monthly
    @target_time = Time.current.all_month
    @ranks = Record.unscope(:order)
                   .select("user_id
                           ,(sum(grade_id) + sum(strong_point)) * 10 as score
                           ,RANK () OVER (ORDER BY (sum(grade_id) + sum(strong_point)) * 10 DESC) as rank_number")
                   .where(created_at: @target_time)
                   .group("user_id")
                   .order("score DESC")
  end
end
