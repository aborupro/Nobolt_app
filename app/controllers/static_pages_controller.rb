class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # 空のマイクロポストを作成する
      @micropost  = current_user.microposts.build
      # カレントユーザがフォローしているユーザとカレントユーザのステータスフィードを返す
      @feed_items = current_user.feed.paginate(page: params[:page])
      # カレントユーザがフォローしているユーザとカレントユーザの記録を返す
      @following_record_items  = current_user.following_record.paginate(page: params[:page])
    end
  end

  def help
  end
end
