require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe "GET /session/login" do
    it "returns http success" do
      get new_session_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /session" do
    context "with valid credentials" do
      it "logs in the user and redirects to root" do
        post session_path, params: { session: { email: user.email, password: user.password } }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("ログインしました")
      end
    end

    context "with invalid credentials" do
      it "renders the login form with error message" do
        post session_path, params: { session: { email: user.email, password: "wrong" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("メールアドレスまたはパスワードが正しくありません")
      end
    end
  end

  describe "DELETE /session" do
    before do
      post session_path, params: { session: { email: user.email, password: user.password } }
    end

    it "logs out the user and redirects to root" do
      delete session_path
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("ログアウトしました")
    end
  end
end
