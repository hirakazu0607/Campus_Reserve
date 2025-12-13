class UsersController < ApplicationController
  def new
    # @userを作成してViewに渡す
    # @をつけると、new.html.erbで使える
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # 成功した場合、flashメッセージを表示してホームに戻る
      flash[:success] = "✅ ユーザー登録が完了しました！"
      redirect_to root_path
    else
      # 失敗した場合、フォームを再表示
      render :new, status: :unprocessable_content
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :student_or_staff_number, :email, :password, :password_confirmation, :role)
  end
end
