class GymsController < ApplicationController
  def index
    if params[:name]
      @gyms = Gym.all
    end
  end

  def show
    @gym = Gym.find(params[:id])
  end

  def new
    if params[:search].present?
      @keyword = params[:search]
      @client = GooglePlaces::Client.new( ENV['GOOGLE_API_KEY'] )
      @gyms = @client.spots_by_query( @keyword + "ボルダリング", language: 'ja', region: 'ja' )
    end

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
  end

  def create
    @gym = Gym.new(gym_params)
    if @gym.save
      flash[:info] = "#{@gym.name} を保存しました"
      @selected_prefecture = @gym.prefecture
      @selected_gym_name = @gym.name

      gyms = Gym.where(prefecture: @selected_prefecture)
      @gym_name = []
      gyms.each do |gym|
        @gym_name.push(gym.name)
      end
      @gym_name.sort!
      @record = Record.new

      render("records/new")
    else
      flash[:danger] = "#{@gym.name} を保存できませんでした"
      render 'new'
    end
  end

  def destroy
    @gym.destroy

    respond_to do |format|
      format.html { redirect_to place_index_path, notice: "#{@place.name} の位置情報を削除しました" }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gym
      @gym = Gym.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gym_params
      params.require(:gym).permit(:name, :prefecture, :address, :picture, :url, :business_hours, :price)
    end

end
