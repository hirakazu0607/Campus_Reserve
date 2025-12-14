class SessionsController < ApplicationController
  def new
    # ログインフォームを表示
  end

  def create
    # ログイン処理
    user = User.find_by(email: params[:session][:email].downcase)

    if user&.authenticate(params[:session][:password])
      # ログイン成功
      log_in(user)
      flash[:success] = "ログインしました"
      redirect_to root_path
    else
      # ログイン失敗
      flash.now[:danger] = "メールアドレスまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # ログアウト処理
    log_out if logged_in?
    flash[:success] = "ログアウトしました"
    redirect_to root_path
  end
end
