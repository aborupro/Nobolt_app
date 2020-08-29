class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                          :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    # @microposts = @user.microposts.paginate(page: params[:page])
    # @records = @user.records.includes(:gym, :grade, :likes).paginate(page: params[:page])

    if params[:gym_select].present?
      @gym_select = params[:gym_select]
    else
      @gym_select = Gym.pluck("id")
    end

    if params[:grade_select].present?
      @grade_select = params[:grade_select]
    else
      @grade_select = Grade.pluck("id")
    end
    
    @grade_stats = Record.joins(:grade)
                         .joins(:gym)
                         .unscope(:order)
                         .select("grades.name as grade_name,
                                  count(*) as record_num,
                                  grades.id as grade_id")
                         .where("records.user_id = ?", @user.id)
                         .where("records.grade_id in (?)", @grade_select)
                         .where("records.gym_id in (?)", @gym_select)
                         .group("records.grade_id")
                         .order("records.grade_id")

    @gym_stats = Record.joins(:grade)
                       .joins(:gym)
                       .unscope(:order)
                       .select("gyms.name as gym_name,
                               count(*) as record_num,
                               gyms.id as gym_id")
                       .where("records.user_id = ?", @user.id)
                       .where("records.grade_id in (?)", @grade_select)
                       .where("records.gym_id in (?)", @gym_select)
                       .group("records.gym_id")
                       .order("records.gym_id")
    
    @records = @user.records
                    .where("grade_id in (?)", @grade_select)
                    .where("gym_id in (?)", @gym_select)
                    .includes(:gym, :grade, :likes).paginate(page: params[:page])

    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "アカウントを有効にするために、メールを確認してください"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールの編集に成功しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザを削除しました"
    redirect_to users_url
  end

  def following
    @title = "フォロー中"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :picture)
    end

    # beforeアクション

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
