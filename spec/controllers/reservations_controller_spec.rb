require 'rails_helper'

RSpec.describe ReservationsController, type: :controller do
  let(:student) { create(:user, role: :student) }
  let(:staff) { create(:user, role: :staff, email: 'staff@example.com', student_or_staff_number: 2000) }
  let(:facility) { create(:facility) }
  let(:reservation) { create(:reservation, user: student, facility: facility) }

  describe "GET #index" do
    context "when logged in as student" do
      before { log_in(student) }

      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "shows only the student's reservations" do
        student_reservation = create(:reservation, user: student, facility: facility)
        other_reservation = create(:reservation, user: staff, facility: facility, start_time: 2.days.from_now.change(hour: 14), end_time: 2.days.from_now.change(hour: 16))

        get :index
        expect(assigns(:reservations)).to include(student_reservation)
        expect(assigns(:reservations)).not_to include(other_reservation)
      end
    end

    context "when logged in as staff" do
      before { log_in(staff) }

      it "shows all reservations" do
        reservation1 = create(:reservation, user: student, facility: facility)
        reservation2 = create(:reservation, user: staff, facility: facility, start_time: 2.days.from_now.change(hour: 14), end_time: 2.days.from_now.change(hour: 16))

        get :index
        expect(assigns(:reservations)).to include(reservation1, reservation2)
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        get :index
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "GET #show" do
    context "when logged in" do
      before { log_in(student) }

      it "returns http success" do
        get :show, params: { id: reservation.id }
        expect(response).to have_http_status(:success)
      end

      it "assigns the requested reservation" do
        get :show, params: { id: reservation.id }
        expect(assigns(:reservation)).to eq(reservation)
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        get :show, params: { id: reservation.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "GET #new" do
    context "when logged in" do
      before { log_in(student) }

      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end

      it "assigns a new reservation" do
        get :new
        expect(assigns(:reservation)).to be_a_new(Reservation)
      end

      it "assigns facilities" do
        facility
        get :new
        expect(assigns(:facilities)).to include(facility)
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        get :new
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "POST #create" do
    context "when logged in" do
      before { log_in(student) }

      context "with valid attributes" do
        it "creates a new reservation" do
          expect {
            post :create, params: {
              reservation: {
                facility_id: facility.id,
                start_time: 1.day.from_now.change(hour: 10),
                end_time: 1.day.from_now.change(hour: 12),
                purpose: "Team meeting"
              }
            }
          }.to change(Reservation, :count).by(1)
        end

        it "assigns the reservation to the current user" do
          post :create, params: {
            reservation: {
              facility_id: facility.id,
              start_time: 1.day.from_now.change(hour: 10),
              end_time: 1.day.from_now.change(hour: 12)
            }
          }
          expect(Reservation.last.user).to eq(student)
        end

        it "redirects to the reservation show page" do
          post :create, params: {
            reservation: {
              facility_id: facility.id,
              start_time: 1.day.from_now.change(hour: 10),
              end_time: 1.day.from_now.change(hour: 12)
            }
          }
          expect(response).to redirect_to(reservation_path(Reservation.last))
        end
      end

      context "with invalid attributes" do
        it "does not create a new reservation" do
          expect {
            post :create, params: {
              reservation: {
                facility_id: facility.id,
                start_time: nil,
                end_time: nil
              }
            }
          }.not_to change(Reservation, :count)
        end

        it "renders the new template" do
          post :create, params: {
            reservation: {
              facility_id: facility.id,
              start_time: nil,
              end_time: nil
            }
          }
          expect(response).to render_template(:new)
        end
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        post :create, params: {
          reservation: {
            facility_id: facility.id,
            start_time: 1.day.from_now.change(hour: 10),
            end_time: 1.day.from_now.change(hour: 12)
          }
        }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "GET #edit" do
    context "when logged in as reservation owner" do
      before { log_in(student) }

      it "returns http success for pending reservation" do
        get :edit, params: { id: reservation.id }
        expect(response).to have_http_status(:success)
      end

      it "redirects for approved reservation" do
        reservation.approved!
        get :edit, params: { id: reservation.id }
        expect(response).to redirect_to(reservation_path(reservation))
      end
    end

    context "when logged in as different user" do
      before { log_in(staff) }

      it "redirects when trying to edit another user's reservation" do
        get :edit, params: { id: reservation.id }
        expect(response).to redirect_to(reservations_path)
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        get :edit, params: { id: reservation.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "PATCH #update" do
    context "when logged in as reservation owner" do
      before { log_in(student) }

      context "with valid attributes" do
        it "updates the reservation" do
          patch :update, params: {
            id: reservation.id,
            reservation: { purpose: "Updated purpose" }
          }
          reservation.reload
          expect(reservation.purpose).to eq("Updated purpose")
        end

        it "redirects to the reservation show page" do
          patch :update, params: {
            id: reservation.id,
            reservation: { purpose: "Updated purpose" }
          }
          expect(response).to redirect_to(reservation_path(reservation))
        end
      end

      context "with invalid attributes" do
        it "does not update the reservation" do
          original_start = reservation.start_time
          patch :update, params: {
            id: reservation.id,
            reservation: { start_time: nil }
          }
          reservation.reload
          expect(reservation.start_time).to eq(original_start)
        end

        it "renders the edit template" do
          patch :update, params: {
            id: reservation.id,
            reservation: { start_time: nil }
          }
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        patch :update, params: {
          id: reservation.id,
          reservation: { purpose: "Updated" }
        }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when logged in as reservation owner" do
      before { log_in(student) }

      it "cancels the reservation" do
        delete :destroy, params: { id: reservation.id }
        reservation.reload
        expect(reservation.cancelled?).to be true
      end

      it "redirects to reservations index" do
        delete :destroy, params: { id: reservation.id }
        expect(response).to redirect_to(reservations_path)
      end
    end

    context "when logged in as different user" do
      before { log_in(staff) }

      it "redirects when trying to cancel another user's reservation" do
        delete :destroy, params: { id: reservation.id }
        expect(response).to redirect_to(reservations_path)
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        delete :destroy, params: { id: reservation.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "PATCH #approve" do
    context "when logged in as staff" do
      before { log_in(staff) }

      it "approves the reservation" do
        patch :approve, params: { id: reservation.id }
        reservation.reload
        expect(reservation.approved?).to be true
      end

      it "redirects to the reservation show page" do
        patch :approve, params: { id: reservation.id }
        expect(response).to redirect_to(reservation_path(reservation))
      end
    end

    context "when logged in as student" do
      before { log_in(student) }

      it "redirects to root path" do
        patch :approve, params: { id: reservation.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        patch :approve, params: { id: reservation.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "PATCH #reject" do
    context "when logged in as staff" do
      before { log_in(staff) }

      it "rejects the reservation" do
        patch :reject, params: { id: reservation.id }
        reservation.reload
        expect(reservation.rejected?).to be true
      end

      it "redirects to the reservation show page" do
        patch :reject, params: { id: reservation.id }
        expect(response).to redirect_to(reservation_path(reservation))
      end
    end

    context "when logged in as student" do
      before { log_in(student) }

      it "redirects to root path" do
        patch :reject, params: { id: reservation.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        patch :reject, params: { id: reservation.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  # Helper method for logging in during tests
  def log_in(user)
    session[:user_id] = user.id
  end
end
