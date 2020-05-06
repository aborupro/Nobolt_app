class RecordsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,   only: :destroy
  before_action :set_value,      only: [:new, :search]
  after_action  :set_value,      only: :create

  def index
    @records = Record.includes(:grade, :gym, :user).paginate(page: params[:page])
  end

  def new
    @record = Record.new
    render "new"
  end

  def create
    @record = current_user.records.build(record_params)
    if params[:record]["gym_name"].present?
      gym_name = Gym.find_by(name: params[:record]["gym_name"])
      @record.gym_id = gym_name.id
    end
    if params[:record]["grade"].present?
      grade = Grade.find_by(name: params[:record]["grade"])
      @record.grade_id = grade.id
    end
    flash.now[:info] = "記録を保存しました" if @record.save
    set_value
    render 'new'
  end

  def destroy
    @record.destroy
    flash[:success] = "記録を削除しました"
    redirect_to request.referrer || root_url
  end

  def search
    @record = Record.new
    respond_to do |format|
      format.html { render 'new' }
      format.js
    end
  end

  def rank
    set_rank_value
  end

  def graph
    
  end

  private
  def record_params
    params.require(:record).permit(:challenge, :strong_point, :picture)
  end

  def set_value
    if params[:selection_gym_name].present?
      @gym_name = params[:selection_gym_name]
    else
      if Record.find_by(user_id: current_user.id).present?
        latest_record = Record.find_by(user_id: current_user.id)
        @gym_name = Gym.find(latest_record.gym_id).name
      else
        flash[:info] = "まずは、ジムを選択してください"
        redirect_to gyms_path
      end
    end
  end

  def set_rank_value
    all_term = "全期間"
    all_gym = "全てのジム"

    @month_choice = [all_term] + (Record.last[:created_at].to_date.beginning_of_month..Date.today)
    .select{|date| date.day == 1 }.map { |item| item.strftime("%Y年%m月")}.reverse
    
    @gym_choice = [all_gym] + Gym.pluck("name")

    if params[:month].present?
      if params[:month] != all_term
        @begin_time = Date.strptime(params[:month], '%Y年%m月').beginning_of_month
        @end_time = Date.strptime(params[:month], '%Y年%m月').end_of_month

      else
        @begin_time = Record.last[:created_at].to_date.beginning_of_month
        @end_time = Date.today.end_of_month
      end
      @selected_month = params[:month]
    else
      @begin_time = Time.current.beginning_of_month
      @end_time = Time.current.end_of_month
      @selected_month = Time.current.strftime("%Y年%m月")
    end

    if params[:gym].present? && params[:gym] != all_gym
      @target_gym = Gym.find_by(name: params[:gym]).id
      @selected_gym = params[:gym]
    else
      @target_gym = Gym.pluck("id")
      @selected_gym = all_gym
    end

    query = ActiveRecord::Base.sanitize_sql_array(['
      select user_id,
             score,
             (select (COUNT(*) + 1)
             from (select r.user_id,
                           (sum(g.grade_point) + sum(r.strong_point)) * 10 as score
                   from records as r
                   inner join grades as g
                           on r.grade_id = g.id
                           where (r.gym_id in (:gym_ids)) and (r.created_at between :begin_times and :end_times)
                   group by r.user_id
                   order by score DESC) as s1
             where s2.score < s1.score) as rank_number
      from
      (select r.user_id,
              (sum(g.grade_point) + sum(r.strong_point)) * 10 as score
      from records as r
      inner join grades as g
              on r.grade_id = g.id
      where (r.gym_id in (:gym_ids)) and (r.created_at between :begin_times and :end_times)
      group by r.user_id
      order by score DESC) as s2;
      ', gym_ids: @target_gym, begin_times: @begin_time, end_times: @end_time])

    @ranks = ActiveRecord::Base.connection.select_all(query)
    
    @my_rank = 0
    @ranks.each_with_index do |rank, i|
      if rank["user_id"] == current_user.id
        # @my_rank = rank.rank_number
        @my_rank = rank["rank_number"]
        break
      end
    end
    @total_user = @ranks.count
    @ranks = @ranks.to_a.paginate(page: params[:page], per_page: 100)
  end

  def correct_user
    @record = current_user.records.find_by(id: params[:id])
    redirect_to root_url if @record.nil?
  end
end
