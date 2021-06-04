class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    # カレントユーザがフォローしているユーザとカレントユーザの記録を返す
    @following_record_items = current_user.following_record.paginate(page: params[:page])
  end
end
