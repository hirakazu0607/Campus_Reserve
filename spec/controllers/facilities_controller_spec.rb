require 'rails_helper'

RSpec.describe FacilitiesController, type: :controller do
  let(:student) { create(:user, role: :student) }
  let(:staff) { create(:user, role: :staff, email: 'staff@example.com', student_or_staff_number: 2000) }
  let(:facility) { create(:facility) }

  describe "GET #index" do
    context "when logged in" do
      before { log_in(student) }

      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns all facilities" do
        facility1 = create(:facility)
        facility2 = create(:facility, name: "Lecture Room")
        get :index
        expect(assigns(:facilities)).to match_array([ facility1, facility2 ])
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
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
        get :show, params: { id: facility.id }
        expect(response).to have_http_status(:success)
      end

      it "assigns the requested facility" do
        get :show, params: { id: facility.id }
        expect(assigns(:facility)).to eq(facility)
      end

      it "renders the show template" do
        get :show, params: { id: facility.id }
        expect(response).to render_template(:show)
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        get :show, params: { id: facility.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "GET #new" do
    context "when logged in as staff" do
      before { log_in(staff) }

      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end

      it "assigns a new facility" do
        get :new
        expect(assigns(:facility)).to be_a_new(Facility)
      end

      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context "when logged in as student" do
      before { log_in(student) }

      it "redirects to facilities path" do
        get :new
        expect(response).to redirect_to(facilities_path)
      end

      it "sets a danger flash message" do
        get :new
        expect(flash[:danger]).to eq("この操作は職員のみ実行できます")
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
    context "when logged in as staff" do
      before { log_in(staff) }

      context "with valid attributes" do
        let(:valid_attributes) do
          {
            name: "New Facility",
            description: "A test facility",
            capacity: 50,
            location: "Building A, Room 101"
          }
        end

        it "creates a new facility" do
          expect {
            post :create, params: { facility: valid_attributes }
          }.to change(Facility, :count).by(1)
        end

        it "redirects to the facility show page" do
          post :create, params: { facility: valid_attributes }
          expect(response).to redirect_to(facility_path(Facility.last))
        end

        it "sets a success flash message" do
          post :create, params: { facility: valid_attributes }
          expect(flash[:success]).to be_present
        end
      end

      context "with invalid attributes" do
        let(:invalid_attributes) do
          {
            name: nil,
            capacity: nil,
            location: nil
          }
        end

        it "does not create a new facility" do
          expect {
            post :create, params: { facility: invalid_attributes }
          }.not_to change(Facility, :count)
        end

        it "renders the new template" do
          post :create, params: { facility: invalid_attributes }
          expect(response).to render_template(:new)
        end
      end
    end

    context "when logged in as student" do
      before { log_in(student) }

      it "redirects to facilities path" do
        post :create, params: { facility: { name: "Test", capacity: 50, location: "Test" } }
        expect(response).to redirect_to(facilities_path)
      end

      it "does not create a new facility" do
        expect {
          post :create, params: { facility: { name: "Test", capacity: 50, location: "Test" } }
        }.not_to change(Facility, :count)
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        post :create, params: { facility: { name: "Test", capacity: 50, location: "Test" } }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "GET #edit" do
    context "when logged in as staff" do
      before { log_in(staff) }

      it "returns http success" do
        get :edit, params: { id: facility.id }
        expect(response).to have_http_status(:success)
      end

      it "assigns the requested facility" do
        get :edit, params: { id: facility.id }
        expect(assigns(:facility)).to eq(facility)
      end

      it "renders the edit template" do
        get :edit, params: { id: facility.id }
        expect(response).to render_template(:edit)
      end
    end

    context "when logged in as student" do
      before { log_in(student) }

      it "redirects to facilities path" do
        get :edit, params: { id: facility.id }
        expect(response).to redirect_to(facilities_path)
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        get :edit, params: { id: facility.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "PATCH #update" do
    context "when logged in as staff" do
      before { log_in(staff) }

      context "with valid attributes" do
        let(:new_attributes) do
          {
            name: "Updated Facility",
            description: "Updated description",
            capacity: 100
          }
        end

        it "updates the facility" do
          patch :update, params: { id: facility.id, facility: new_attributes }
          facility.reload
          expect(facility.name).to eq("Updated Facility")
          expect(facility.capacity).to eq(100)
        end

        it "redirects to the facility show page" do
          patch :update, params: { id: facility.id, facility: new_attributes }
          expect(response).to redirect_to(facility_path(facility))
        end

        it "sets a success flash message" do
          patch :update, params: { id: facility.id, facility: new_attributes }
          expect(flash[:success]).to be_present
        end
      end

      context "with invalid attributes" do
        let(:invalid_attributes) do
          {
            name: nil,
            capacity: -1
          }
        end

        it "does not update the facility" do
          original_name = facility.name
          patch :update, params: { id: facility.id, facility: invalid_attributes }
          facility.reload
          expect(facility.name).to eq(original_name)
        end

        it "renders the edit template" do
          patch :update, params: { id: facility.id, facility: invalid_attributes }
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when logged in as student" do
      before { log_in(student) }

      it "redirects to facilities path" do
        patch :update, params: { id: facility.id, facility: { name: "Updated" } }
        expect(response).to redirect_to(facilities_path)
      end

      it "does not update the facility" do
        original_name = facility.name
        patch :update, params: { id: facility.id, facility: { name: "Updated" } }
        facility.reload
        expect(facility.name).to eq(original_name)
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        patch :update, params: { id: facility.id, facility: { name: "Updated" } }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when logged in as staff" do
      before { log_in(staff) }

      it "deletes the facility" do
        facility_to_delete = create(:facility, name: "To Delete")
        expect {
          delete :destroy, params: { id: facility_to_delete.id }
        }.to change(Facility, :count).by(-1)
      end

      it "redirects to facilities index" do
        delete :destroy, params: { id: facility.id }
        expect(response).to redirect_to(facilities_path)
      end

      it "sets a success flash message" do
        delete :destroy, params: { id: facility.id }
        expect(flash[:success]).to be_present
      end
    end

    context "when logged in as student" do
      before { log_in(student) }

      it "redirects to facilities path" do
        delete :destroy, params: { id: facility.id }
        expect(response).to redirect_to(facilities_path)
      end

      it "does not delete the facility" do
        facility_to_delete = create(:facility, name: "To Delete")
        expect {
          delete :destroy, params: { id: facility_to_delete.id }
        }.not_to change(Facility, :count)
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        delete :destroy, params: { id: facility.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  # Helper method for logging in during tests
  def log_in(user)
    session[:user_id] = user.id
  end
end
