class StaticPagesController < ApplicationController
  def index
    if logged_in?
      # ログイン済み：カレンダー表示
      @date = params[:date] ? Date.parse(params[:date]) : Date.today
      @reservations = Reservation.where(
        "DATE(start_time) >= ? AND DATE(start_time) <= ?",
        @date.beginning_of_month,
        @date.end_of_month
      ).includes(:facility, :user)

      # 予約がある日付のセットを作成
      @reserved_dates = @reservations.map { |r| r.start_time.to_date }.uniq
    end
    # 未ログイン：ランディングページ表示
  end

  def about
    # Aboutページ
  end

  def help
    # Helpページ
  end
end
