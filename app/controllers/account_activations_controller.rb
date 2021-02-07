class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = 'メールアドレスを確認できました!'
      redirect_to user
    else
      flash[:danger] = 'メールアドレスの認証エラー'
      redirect_to root_url
    end
  end
end
