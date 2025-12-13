require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = reservations(:one)
  end

  test "should get index" do
    get reservations_url
    assert_response :success
  end

  test "should get new" do
    get new_reservation_url
    assert_response :success
  end

  test "should create reservation" do
    assert_difference("Reservation.count") do
      post reservations_url, params: { reservation: { 
        end_time: 5.days.from_now.change(hour: 18, min: 0), 
        facility_id: @reservation.facility_id, 
        purpose: "Test Purpose", 
        start_time: 5.days.from_now.change(hour: 16, min: 0), 
        status: "pending", 
        user_email: "newtest@example.com", 
        user_name: "New Test User" 
      } }
    end

    assert_redirected_to reservation_url(Reservation.last)
  end

  test "should show reservation" do
    get reservation_url(@reservation)
    assert_response :success
  end

  test "should get edit" do
    get edit_reservation_url(@reservation)
    assert_response :success
  end

  test "should update reservation" do
    patch reservation_url(@reservation), params: { reservation: { 
      end_time: @reservation.end_time, 
      facility_id: @reservation.facility_id, 
      purpose: "Updated Purpose", 
      start_time: @reservation.start_time, 
      status: @reservation.status, 
      user_email: @reservation.user_email, 
      user_name: @reservation.user_name 
    } }
    assert_redirected_to reservation_url(@reservation)
  end

  test "should destroy reservation" do
    assert_difference("Reservation.count", -1) do
      delete reservation_url(@reservation)
    end

    assert_redirected_to reservations_url
  end
end
