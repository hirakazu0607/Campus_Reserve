class ReservationsController < ApplicationController
  before_action :require_login

  before_action :set_reservation, only: [ :show, :edit, :update, :destroy, :approve, :reject ]
  before_action :authorize_user, only: [ :edit, :update, :destroy ]
  before_action :require_staff, only: [ :approve, :reject ]

  # GET /reservations
  def index
    if current_user.staff?
      # Staff can see all reservations
      @reservations = Reservation.includes(:user, :facility).order(start_time: :desc)
    else
      # Students see only their own reservations
      @reservations = current_user.reservations.includes(:facility).order(start_time: :desc)
    end
  end

  # GET /reservations/:id
  def show
    # Anyone can view any reservation details
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new

    # カレンダーから日付が渡された場合、開始時刻と終了時刻を設定
    if params[:date].present?
      date = Date.parse(params[:date])
      @reservation.start_time = date.to_time.change(hour: 10, min: 0)
      @reservation.end_time = date.to_time.change(hour: 12, min: 0)
    end

    @facilities = Facility.all
  end

  # POST /reservations
  def create
    @reservation = current_user.reservations.build(reservation_params)

    if @reservation.save
      redirect_to @reservation, notice: "予約を作成しました"
    else
      @facilities = Facility.all
      render :new, status: :unprocessable_entity
    end
  end

  # GET /reservations/:id/edit
  def edit
    # Only pending reservations can be edited
    unless @reservation.pending?
      redirect_to @reservation, alert: "承認待ちの予約のみ編集できます"
      return
    end
    @facilities = Facility.all
  end

  # PATCH/PUT /reservations/:id
  def update
    unless @reservation.pending?
      redirect_to @reservation, alert: "承認待ちの予約のみ更新できます"
      return
    end

    if @reservation.update(reservation_params)
      redirect_to @reservation, notice: "予約を更新しました"

    else
      @facilities = Facility.all
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reservations/:id
  def destroy
    @reservation.cancelled!
    redirect_to reservations_path, notice: "予約をキャンセルしました"
  end

  # PATCH /reservations/:id/approve
  def approve
    @reservation.approved!
    redirect_to @reservation, notice: "予約を承認しました"
  end

  # PATCH /reservations/:id/reject
  def reject
    @reservation.rejected!
    redirect_to @reservation, notice: "予約を拒否しました"
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def authorize_user
    unless @reservation.user == current_user
      redirect_to reservations_path, alert: "この操作を行う権限がありません"
    end
  end

  def reservation_params
    params.require(:reservation).permit(:facility_id, :start_time, :end_time, :purpose)
  end
end
