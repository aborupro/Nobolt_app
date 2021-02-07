class GymsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: :destroy
  def index
    @q = Gym.ransack(params[:q])
    @gyms = @q.result.page(params[:page]).order('name ASC')
  end

  def new
    @gym = Gym.new
  end

  def search
    if params[:search].present?
      @keyword = params[:search]
      @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
      @gyms = @client.spots_by_query(@keyword + 'ボルダリング', language: 'ja', region: 'ja')
    end

    @gym = Gym.new
    render 'new'
  end

  def choose
    if params[:gym_name] && params[:gym_address]
      @gym_name = params[:gym_name]
      @gym_address = params[:gym_address]

      regions = %W[\u5317\u6D77\u9053 \u9752\u68EE\u770C \u5CA9\u624B\u770C \u5BAE\u57CE\u770C \u79CB\u7530\u770C \u5C71\u5F62\u770C \u798F\u5CF6\u770C
                   \u8328\u57CE\u770C \u6803\u6728\u770C \u7FA4\u99AC\u770C \u57FC\u7389\u770C \u5343\u8449\u770C \u6771\u4EAC\u90FD \u795E\u5948\u5DDD\u770C
                   \u65B0\u6F5F\u770C \u5BCC\u5C71\u770C \u77F3\u5DDD\u770C \u798F\u4E95\u770C \u5C71\u68A8\u770C \u9577\u91CE\u770C \u5C90\u961C\u770C
                   \u9759\u5CA1\u770C \u611B\u77E5\u770C \u4E09\u91CD\u770C \u6ECB\u8CC0\u770C \u4EAC\u90FD\u5E9C \u5927\u962A\u5E9C \u5175\u5EAB\u770C
                   \u5948\u826F\u770C \u548C\u6B4C\u5C71\u770C \u9CE5\u53D6\u770C \u5CF6\u6839\u770C \u5CA1\u5C71\u770C \u5E83\u5CF6\u770C \u5C71\u53E3\u770C
                   \u5FB3\u5CF6\u770C \u9999\u5DDD\u770C \u611B\u5A9B\u770C \u9AD8\u77E5\u770C \u798F\u5CA1\u770C \u4F50\u8CC0\u770C \u9577\u5D0E\u770C
                   \u718A\u672C\u770C \u5927\u5206\u770C \u5BAE\u5D0E\u770C \u9E7F\u5150\u5CF6\u770C \u6C96\u7E04\u770C]

      regions.each do |region|
        @gym_prefecture = params[:gym_address][region]
        break if @gym_prefecture == region
      end
    end

    @gym = Gym.new
    render 'new'
  end

  def create
    @gym = Gym.new(gym_params)
    if @gym.save
      flash.now[:info] = "#{@gym.name} を保存しました"
      @selected_prefecture = (JpPrefecture::Prefecture.find @gym.prefecture_code).name
      @selected_gym_name = @gym.name

      gyms = Gym.where(prefecture_code: @gym.prefecture_code)
      @gym_name = []
      gyms.each do |gym|
        @gym_name.push(gym.name)
      end
      @gym_name.sort!
      @record = Record.new

      render('records/new')
    else
      @gym_name = params[:gym][:name]
      @gym_address = params[:gym][:address]
      @gym_prefecture = (JpPrefecture::Prefecture.find params[:gym][:prefecture_code]).name
      render 'new'
    end
  end

  def edit
    @gym = Gym.find(params[:id])
  end

  def update
    @gym = Gym.find(params[:id])
    flash.now[:success] = 'ジムの編集に成功しました' if @gym.update_attributes(gym_params)
    render 'edit'
  end

  def destroy
    @gym.destroy
    flash[:success] = 'ジムを削除しました'
    redirect_to gyms_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_gym
    @gym = Gym.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def gym_params
    params.require(:gym).permit(:name, :prefecture_code, :address, :picture, :url, :business_hours, :price)
  end

  # 管理者かどうか確認
  def admin_user
    @gym = Gym.find(params[:id])
    redirect_to(gyms_url) unless current_user.admin?
  end
end
