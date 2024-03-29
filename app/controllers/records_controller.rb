class RecordsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: :destroy
  before_action :set_gym, only: %i[new search]

  def index
    @records = Record.includes(:grade, :gym, :user, :likes).paginate(page: params[:page])
  end

  def show
    @like = Like.new
  end

  def new
    @record = Record.new
    render 'new'
  end

  def create
    @record = current_user.records.build(record_params)
    if params[:record]['gym_name'].present?
      gym_name = Gym.find_by(name: params[:record]['gym_name'])
      @record.gym_id = gym_name.id
    end
    if params[:record]['grade'].present?
      grade = Grade.find_by(name: params[:record]['grade'])
      @record.grade_id = grade.id
    end
    flash.now[:info] = '記録を保存しました' if @record.save
    set_gym
    render 'new'
  end

  def destroy
    @record.destroy
    flash[:success] = '記録を削除しました'
    redirect_to request.referrer || root_url
  end

  def rank
    query = cal_query
    rank_value(query)
  end

  def graph
    cal_graph
  end

  private

  def record_params
    params.require(:record).permit(:challenge, :strong_point, :picture)
  end

  def graph_time(time_format)
    @graph_value = Record.joins(:grade)
                         .unscope(:order)
                         .select("(sum(grade_point) + sum(strong_point))*10 as score,
                                 date_format(records.created_at ,'#{time_format}') as date")
                         .where('records.user_id = ?', current_user.id)
                         .where('records.created_at between ? and ?', @from, @to)
                         .group('date')
                         .order('date')
  end

  def cal_graph
    @count = 0
    @chart_pre = true
    @chart_next = true
    @chart = []

    # 集計単位を判別
    @selected_term = if params[:term].present?
                       params[:term]
                     else
                       'day'
                     end

    # 集計の基準日を計算
    if params[:pre_preview].present?
      case @selected_term
      when 'month'
        @from_to = Date.parse(params[:pre_preview]) << 6
      when 'week'
        @from_to = Date.parse(params[:pre_preview]) - 7 * 8
      when 'day'
        @from_to = Date.parse(params[:pre_preview]) - 7
      end
    elsif params[:next_preview].present?
      case @selected_term
      when 'month'
        @from_to = Date.parse(params[:next_preview]) >> 6
      when 'week'
        @from_to = Date.parse(params[:next_preview]) + 7 * 8
      when 'day'
        @from_to = Date.parse(params[:next_preview]) + 7
      end
    else
      @from_to = if params[:from_to].present?
                   Date.parse(params[:from_to])
                 else
                   Time.current.to_date
                 end
    end

    # グラフの値を計算
    case @selected_term
    when 'month'
      @selected_term_jp = '月'
      if @from_to.strftime('%m').to_i < 7
        # 1/1~6/30
        @from = @from_to.beginning_of_year.to_date
        @to = @from.since(5.month).end_of_month.to_date
      else
        # 7/1~12/31
        @from = @from_to.end_of_year.ago(5.months).beginning_of_month.to_date
        @to = @from_to.end_of_year.to_date
      end

      graph_time('%Y/%m')

      6.times do |i|
        t = (@from >> i).strftime('%Y/%m')
        temp_score = 0
        @graph_value.each do |g|
          temp_score = g.score.to_i if t == g.date
        end
        @chart.append([t, temp_score])
      end
    when 'week'
      @selected_term_jp = '週'

      @from = @from_to.ago(7.weeks).beginning_of_week(:sunday).to_date
      @to = @from_to.end_of_week(:sunday).to_date

      graph_time('%Y/%U weeks')

      8.times do |i|
        t = (@from + i * 7)
        temp_score = 0
        @graph_value.each do |g|
          temp_score = g.score.to_i if (t + 1).strftime('%Y/%U weeks') == g.date
        end
        @chart.append([t.strftime('%Y/%m/%d週').to_s, temp_score])
      end
    when 'day'
      @selected_term_jp = '日'

      @from = @from_to.beginning_of_week(:sunday).to_date
      @to = @from_to.end_of_week(:sunday).to_date

      graph_time('%Y/%m/%d')

      7.times do |i|
        t = (@from + i).strftime('%Y/%m/%d')
        temp_score = 0
        @graph_value.each do |g|
          temp_score = g.score.to_i if t == g.date
        end
        @chart.append([t + "(#{%w[日 月 火 水 木 金 土][i]})", temp_score])
      end
    end

    # 前の日付が記録を始めた時期より前だったら、左矢印を非活性状態にする
    if Record.where(user_id: current_user.id).blank? \
       || @from <= Record.where(user_id: current_user.id).last.created_at.to_date
      @chart_pre = false
    end
    # 次の日付が未来だったら、右矢印を非活性状態にする
    @chart_next = false if @to >= Date.today

    @from = @from.strftime('%Y/%m/%d')
    @to = @to.strftime('%Y/%m/%d')
  end

  def set_gym
    if params[:selection_gym_name].present?
      @gym_name = params[:selection_gym_name]
    elsif Record.find_by(user_id: current_user.id).present?
      latest_record = Record.find_by(user_id: current_user.id)
      @gym_name = Gym.find(latest_record.gym_id).name
    else
      flash[:info] = 'まずは、ジムを選択してください'
      redirect_to gyms_path
    end
  end

  def cal_query
    all_term = '全期間'
    all_gym = '全てのジム'

    @month_choice = [all_term] + (Record.last[:created_at].to_date.beginning_of_month..Date.today)
                    .select { |date| date.day == 1 }.map { |item| item.strftime('%Y年%m月') }.reverse

    @gym_choice = [all_gym] + Gym.pluck('name')

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
      @selected_month = Time.current.strftime('%Y年%m月')
    end

    if params[:gym].present? && params[:gym] != all_gym
      @target_gym = Gym.find_by(name: params[:gym]).id
      @selected_gym = params[:gym]
    else
      @target_gym = Gym.pluck('id')
      @selected_gym = all_gym
    end

    ActiveRecord::Base.sanitize_sql_array(['
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
      ', { gym_ids: @target_gym, begin_times: @begin_time, end_times: @end_time }])
  end

  def rank_value(query)
    @ranks = ActiveRecord::Base.connection.select_all(query)

    @my_rank = 0
    @ranks.each_with_index do |rank, _i|
      if rank['user_id'] == current_user.id
        @my_rank = rank['rank_number']
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
