class GymsController < ApplicationController
  before_action :logged_in_user, only: [:index, :create, :destroy]
  before_action :admin_user, only: :destroy
  def index
    @q = Gym.ransack(params[:q])
    @gyms = @q.result.page(params[:page]).order('name ASC')
  end

  def show
    @gym = Gym.find(params[:id])
  end

  def new
    @gym = Gym.new
  end

  def search
    if params[:search].present?
      @keyword = params[:search]
      @client = GooglePlaces::Client.new( ENV['GOOGLE_API_KEY'] )
      @gyms = @client.spots_by_query( @keyword + "ボルダリング", language: 'ja', region: 'ja' )
    end

    @gym = Gym.new
    render 'new'
  end

  def choose
    if params[:gym_name] && params[:gym_address]
      @gym_name = params[:gym_name]
      @gym_address = params[:gym_address]

      regions = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県",
        "茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県",
        "新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県",
        "静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県",
        "奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県",
        "徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県",
        "熊本県","大分県","宮崎県","鹿児島県","沖縄県"
      ]

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

      render("records/new")
    else
      @gym_name = params[:gym][:name]
      @gym_address = params[:gym][:address]
      @gym_prefecture = (JpPrefecture::Prefecture.find params[:gym][:prefecture_code]).name
      render 'new'
    end
  end

  def destroy
    @gym.destroy
    flash[:success] = "ジムを削除しました"
    redirect_to request.referrer || root_url
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
