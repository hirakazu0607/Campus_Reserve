class ReservationsController < ApplicationController
  before_action :require_login
  before_action :set_reservation, only: [ :show, :edit, :update, :destroy ]
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
    @facilities = Facility.all
  end

  # POST /reservations
  def create
    @reservation = current_user.reservations.build(reservation_params)

    if @reservation.save
      redirect_to @reservation, notice: "Reservation was successfully created."
    else
      @facilities = Facility.all
      render :new, status: :unprocessable_entity
    end
  end

  # GET /reservations/:id/edit
  def edit
    # Only pending reservations can be edited
    unless @reservation.pending?
      redirect_to @reservation, alert: "Only pending reservations can be edited."
      return
    end
    @facilities = Facility.all
  end

  # PATCH/PUT /reservations/:id
  def update
    unless @reservation.pending?
      redirect_to @reservation, alert: "Only pending reservations can be updated."
      return
    end

    if @reservation.update(reservation_params)
      redirect_to @reservation, notice: "Reservation was successfully updated."
    else
      @facilities = Facility.all
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reservations/:id
  def destroy
    @reservation.cancelled!
    redirect_to reservations_path, notice: "Reservation was cancelled."
  end

  # PATCH /reservations/:id/approve
  def approve
    @reservation = Reservation.find(params[:id])
    @reservation.approved!
    redirect_to @reservation, notice: "Reservation was approved."
  end

  # PATCH /reservations/:id/reject
  def reject
    @reservation = Reservation.find(params[:id])
    @reservation.rejected!
    redirect_to @reservation, notice: "Reservation was rejected."
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def authorize_user
    unless @reservation.user == current_user
      redirect_to reservations_path, alert: "You are not authorized to perform this action."
    end
  end

  def reservation_params
    params.require(:reservation).permit(:facility_id, :start_time, :end_time, :purpose)
  end
end
