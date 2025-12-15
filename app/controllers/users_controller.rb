class UsersController < ApplicationController
  before_action :require_login, only: %i[show edit update]
  before_action :set_user, only: %i[show edit update]
  before_action :correct_user, only: %i[edit update]

  def new
    # @userを作成してViewに渡す
    # @をつけると、new.html.erbで使える
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # 登録成功時は自動ログイン
      log_in(@user)
      flash[:success] = "✅ ユーザー登録が完了しました！"
      redirect_to root_path
    else
      # 失敗した場合、フォームを再表示
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @userはbefore_actionで設定済み
    # プロフィールページを表示
  end

  def edit
    # @userはbefore_actionで設定済み
  end

  def update
    # @userはbefore_actionで設定済み
    if @user.update(user_update_params)
      flash[:success] = "✅ プロフィールを更新しました"
      redirect_to edit_user_path(@user)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :student_or_staff_number, :email, :password, :password_confirmation, :role)
  end

  def user_update_params
    # パスワードが空の場合は更新しない
    if params[:user][:password].blank?
      params.require(:user).permit(:name, :student_or_staff_number, :email)
    else
      params.require(:user).permit(:name, :student_or_staff_number, :email, :password, :password_confirmation)
    end
  end

  # ユーザーを取得
  def set_user
    @user = User.find(params[:id])
  end

  # 本人確認（他人のプロフィールは編集できない）
  def correct_user
    unless @user == current_user
      flash[:danger] = "他のユーザーのプロフィールは編集できません"
      redirect_to root_path
    end
  end
end
