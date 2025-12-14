require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "logs in the user" do
        post :create, params: { session: { email: user.email, password: user.password } }
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to root path" do
        post :create, params: { session: { email: user.email, password: user.password } }
        expect(response).to redirect_to(root_path)
      end

      it "sets a success flash message" do
        post :create, params: { session: { email: user.email, password: user.password } }
        expect(flash[:success]).to eq("ログインしました")
      end
    end

    context "with invalid credentials" do
      it "does not log in the user" do
        post :create, params: { session: { email: user.email, password: "wrong" } }
        expect(session[:user_id]).to be_nil
      end

      it "renders the new template" do
        post :create, params: { session: { email: user.email, password: "wrong" } }
        expect(response).to render_template(:new)
      end

      it "sets a danger flash message" do
        post :create, params: { session: { email: user.email, password: "wrong" } }
        expect(flash[:danger]).to eq("メールアドレスまたはパスワードが正しくありません")
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      post :create, params: { session: { email: user.email, password: user.password } }
    end

    it "logs out the user" do
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root path" do
      delete :destroy
      expect(response).to redirect_to(root_path)
    end

    it "sets a success flash message" do
      delete :destroy
      expect(flash[:success]).to eq("ログアウトしました")
    end
  end
end
