class FacilitiesController < ApplicationController
  before_action :require_login
  before_action :set_facility, only: %i[show edit update destroy]
  before_action :require_staff, only: %i[new create edit update destroy]

  # GET /facilities
  def index
    @facilities = Facility.all.order(created_at: :desc)
  end

  # GET /facilities/:id
  def show
    # @facilityはbefore_actionで設定済み
  end

  # GET /facilities/new
  def new
    @facility = Facility.new
  end

  # POST /facilities
  def create
    @facility = Facility.new(facility_params)

    if @facility.save
      flash[:success] = "✅ 施設を登録しました"
      redirect_to @facility
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /facilities/:id/edit
  def edit
    # @facilityはbefore_actionで設定済み
  end

  # PATCH/PUT /facilities/:id
  def update
    if @facility.update(facility_params)
      flash[:success] = "✅ 施設情報を更新しました"
      redirect_to @facility
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /facilities/:id
  def destroy
    @facility.destroy
    flash[:success] = "✅ 施設を削除しました"
    redirect_to facilities_path
  end

  private

  def set_facility
    @facility = Facility.find(params[:id])
  end

  def facility_params
    params.require(:facility).permit(:name, :description, :capacity, :location)
  end

  # 職員のみアクセス可能
  def require_staff
    unless current_user&.staff?
      flash[:danger] = "この操作は職員のみ実行できます"
      redirect_to facilities_path
    end
  end
end
