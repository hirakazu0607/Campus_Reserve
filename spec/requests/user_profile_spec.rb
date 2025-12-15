require 'rails_helper'

RSpec.describe "User Profile", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "GET /users/:id" do
    context "when not logged in" do
      it "redirects to login page" do
        get user_path(user)
        expect(response).to redirect_to(new_session_path)
        expect(flash[:danger]).to eq("ログインしてください")
      end
    end

    context "when logged in" do
      before do
        post session_path, params: { session: { email: user.email, password: user.password } }
      end

      it "returns http success for own profile" do
        get user_path(user)
        expect(response).to have_http_status(:success)
      end

      it "displays user information" do
        get user_path(user)
        expect(response.body).to include(user.name)
        expect(response.body).to include(user.email)
        expect(response.body).to include(user.student_or_staff_number.to_s)
      end

      it "shows edit button for own profile" do
        get user_path(user)
        expect(response.body).to include("編集")
      end

      it "returns http success for other user's profile" do
        get user_path(other_user)
        expect(response).to have_http_status(:success)
      end

      it "does not show edit button for other user's profile" do
        get user_path(other_user)
        expect(response.body).not_to include("編集")
      end

      it "displays correct role badge for student" do
        student = create(:user, role: :student)
        get user_path(student)
        expect(response.body).to include("🎓 学生")
      end

      it "displays correct role badge for staff" do
        staff = create(:user, role: :staff)
        get user_path(staff)
        expect(response.body).to include("👔 職員")
      end
    end
  end
end
