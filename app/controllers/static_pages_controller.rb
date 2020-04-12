class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # 空のマイクロポストを作成する
      @micropost  = current_user.microposts.build
      # カレントユーザがフォローしているユーザとカレントユーザのステータスフィードを返す
      @feed_items = current_user.feed.paginate(page: params[:page])
      # カレントユーザがフォローしているユーザとカレントユーザの記録を返す
      @following_log_items  = current_user.following_log.paginate(page: params[:page])
      # 全ユーザの記録を返す
      @all_log_items = Record.all
    end
  end

  def help
  end
end
