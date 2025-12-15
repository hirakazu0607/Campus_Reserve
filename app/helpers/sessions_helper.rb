module SessionsHelper
  # ユーザーをログインさせる
  def log_in(user)
    session[:user_id] = user.id
  end

  # 現在ログインしているユーザーを返す
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # ユーザーがログインしているか確認する
  def logged_in?
    !current_user.nil?
  end

  # ユーザーをログアウトさせる
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # 承認待ち予約の件数を取得（スタッフ用）
  def pending_reservations_count
    return 0 unless current_user&.staff?
    @pending_reservations_count ||= Reservation.where(status: :pending).count
  end
end
