require 'rails_helper'

RSpec.describe FacilitiesController, type: :controller do
  include SessionsHelper

  let(:student) { create(:user, role: :student) }
  let(:staff) { create(:user, role: :staff) }
  let(:facility) { create(:facility) }
  let(:valid_attributes) do
    {
      name: "Test Room",
      description: "A test room",
      capacity: 30,
      location: "Building A, Room 101"
    }
  end
  let(:invalid_attributes) do
    {
      name: "",
      capacity: nil,
      location: ""
    }
  end

  describe "authentication" do
    it "requires login for all actions" do
      get :index
      expect(response).to redirect_to(new_session_path)

      get :show, params: { id: facility.id }
      expect(response).to redirect_to(new_session_path)

      get :new
      expect(response).to redirect_to(new_session_path)

      post :create, params: { facility: valid_attributes }
      expect(response).to redirect_to(new_session_path)

      get :edit, params: { id: facility.id }
      expect(response).to redirect_to(new_session_path)

      patch :update, params: { id: facility.id, facility: valid_attributes }
      expect(response).to redirect_to(new_session_path)

      delete :destroy, params: { id: facility.id }
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "authorization" do
    context "when logged in as student" do
      before { log_in student }

      it "allows access to index" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "allows access to show" do
        get :show, params: { id: facility.id }
        expect(response).to have_http_status(:success)
      end

      it "denies access to new" do
        get :new
        expect(response).to redirect_to(facilities_path)
        expect(flash[:danger]).to eq("この操作は職員のみ実行できます")
      end

      it "denies access to create" do
        post :create, params: { facility: valid_attributes }
        expect(response).to redirect_to(facilities_path)
        expect(flash[:danger]).to eq("この操作は職員のみ実行できます")
      end

      it "denies access to edit" do
        get :edit, params: { id: facility.id }
        expect(response).to redirect_to(facilities_path)
        expect(flash[:danger]).to eq("この操作は職員のみ実行できます")
      end

      it "denies access to update" do
        patch :update, params: { id: facility.id, facility: valid_attributes }
        expect(response).to redirect_to(facilities_path)
        expect(flash[:danger]).to eq("この操作は職員のみ実行できます")
      end

      it "denies access to destroy" do
        delete :destroy, params: { id: facility.id }
        expect(response).to redirect_to(facilities_path)
        expect(flash[:danger]).to eq("この操作は職員のみ実行できます")
      end
    end

    context "when logged in as staff" do
      before { log_in staff }

      it "allows access to all actions" do
        get :index
        expect(response).to have_http_status(:success)

        get :show, params: { id: facility.id }
        expect(response).to have_http_status(:success)

        get :new
        expect(response).to have_http_status(:success)

        get :edit, params: { id: facility.id }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #index" do
    before { log_in staff }

    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns all facilities ordered by created_at desc" do
      facility1 = create(:facility, created_at: 2.days.ago)
      facility2 = create(:facility, name: "Newer Facility", created_at: 1.day.ago)

      get :index
      expect(assigns(:facilities)).to eq([ facility2, facility1 ])
    end
  end

  describe "GET #show" do
    before { log_in student }

    it "returns a successful response" do
      get :show, params: { id: facility.id }
      expect(response).to be_successful
    end

    it "assigns the requested facility" do
      get :show, params: { id: facility.id }
      expect(assigns(:facility)).to eq(facility)
    end
  end

  describe "GET #new" do
    before { log_in staff }

    it "returns a successful response" do
      get :new
      expect(response).to be_successful
    end

    it "assigns a new facility" do
      get :new
      expect(assigns(:facility)).to be_a_new(Facility)
    end
  end

  describe "POST #create" do
    before { log_in staff }

    context "with valid parameters" do
      it "creates a new Facility" do
        expect {
          post :create, params: { facility: valid_attributes }
        }.to change(Facility, :count).by(1)
      end

      it "redirects to the created facility" do
        post :create, params: { facility: valid_attributes }
        expect(response).to redirect_to(Facility.last)
      end

      it "sets a success flash message" do
        post :create, params: { facility: valid_attributes }
        expect(flash[:success]).to eq("✅ 施設を登録しました")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Facility" do
        expect {
          post :create, params: { facility: invalid_attributes }
        }.not_to change(Facility, :count)
      end

      it "renders the new template with unprocessable_entity status" do
        post :create, params: { facility: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    before { log_in staff }

    it "returns a successful response" do
      get :edit, params: { id: facility.id }
      expect(response).to be_successful
    end

    it "assigns the requested facility" do
      get :edit, params: { id: facility.id }
      expect(assigns(:facility)).to eq(facility)
    end
  end

  describe "PATCH #update" do
    before { log_in staff }

    context "with valid parameters" do
      let(:new_attributes) do
        {
          name: "Updated Room",
          capacity: 50,
          location: "Building B, Room 202"
        }
      end

      it "updates the requested facility" do
        patch :update, params: { id: facility.id, facility: new_attributes }
        facility.reload
        expect(facility.name).to eq("Updated Room")
        expect(facility.capacity).to eq(50)
        expect(facility.location).to eq("Building B, Room 202")
      end

      it "redirects to the facility" do
        patch :update, params: { id: facility.id, facility: new_attributes }
        expect(response).to redirect_to(facility)
      end

      it "sets a success flash message" do
        patch :update, params: { id: facility.id, facility: new_attributes }
        expect(flash[:success]).to eq("✅ 施設情報を更新しました")
      end
    end

    context "with invalid parameters" do
      it "does not update the facility" do
        original_name = facility.name
        patch :update, params: { id: facility.id, facility: invalid_attributes }
        facility.reload
        expect(facility.name).to eq(original_name)
      end

      it "renders the edit template with unprocessable_entity status" do
        patch :update, params: { id: facility.id, facility: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    before { log_in staff }

    it "destroys the requested facility" do
      facility_to_delete = create(:facility)
      expect {
        delete :destroy, params: { id: facility_to_delete.id }
      }.to change(Facility, :count).by(-1)
    end

    it "redirects to the facilities list" do
      delete :destroy, params: { id: facility.id }
      expect(response).to redirect_to(facilities_path)
    end

    it "sets a success flash message" do
      delete :destroy, params: { id: facility.id }
      expect(flash[:success]).to eq("✅ 施設を削除しました")
    end
  end
end
