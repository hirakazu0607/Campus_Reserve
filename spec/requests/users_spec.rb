require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/new" do
    it "returns http success" do
      get new_user_path
      expect(response).to have_http_status(:success)
    end

    it "renders the new template" do
      get new_user_path
      expect(response.body).to include("ユーザー登録")
    end
  end

  describe "POST /users" do
    context "with valid parameters" do
      let(:valid_attributes) do
        {
          name: "テストユーザー",
          student_or_staff_number: 123456,
          email: "test@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      end

      it "creates a new user" do
        expect {
          post users_path, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "redirects to root path" do
        post users_path, params: { user: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        {
          name: "",
          student_or_staff_number: nil,
          email: "invalid",
          password: "short"
        }
      end

      it "does not create a new user" do
        expect {
          post users_path, params: { user: invalid_attributes }
        }.not_to change(User, :count)
      end

      it "renders the new template" do
        post users_path, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
