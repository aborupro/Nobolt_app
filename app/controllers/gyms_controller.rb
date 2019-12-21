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
    if params[:search].blank?
      File.open("app/assets/data/bouldering_gyms.json") do |file|
        @gyms = JSON.load(file)["results"]
        @flag = 'blank'
      end
    else
      @client = GooglePlaces::Client.new( ENV['GOOGLE_API_KEY'] )
      @gyms = @client.spots_by_query( params[:search] + "ボルダリング", language: 'ja' )
      @flag = 'present'
    end
    @gym = Gym.new
  end

  def create
    @gym = Gym.new(gym_params)
    if @gym.save
      flash[:info] = "#{@gym.name} を保存しました"
      redirect_to gyms_path
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
      params.require(:gym).permit(:name, :address)
    end

end
