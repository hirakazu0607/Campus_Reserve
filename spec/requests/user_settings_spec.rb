require 'rails_helper'

RSpec.describe "User Settings", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "GET /users/:id/edit" do
    context "when not logged in" do
      it "redirects to login page" do
        get edit_user_path(user)
        expect(response).to redirect_to(new_session_path)
        expect(flash[:danger]).to eq("ログインしてください")
      end
    end

    context "when logged in as the correct user" do
      before do
        post session_path, params: { session: { email: user.email, password: user.password } }
      end

      it "returns http success" do
        get edit_user_path(user)
        expect(response).to have_http_status(:success)
      end

      it "renders the edit template" do
        get edit_user_path(user)
        expect(response.body).to include("プロフィール編集")
      end
    end

    context "when trying to edit another user's profile" do
      before do
        post session_path, params: { session: { email: user.email, password: user.password } }
      end

      it "redirects to root path" do
        get edit_user_path(other_user)
        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq("他のユーザーのプロフィールは編集できません")
      end
    end
  end

  describe "PATCH /users/:id" do
    before do
      post session_path, params: { session: { email: user.email, password: user.password } }
    end

    context "with valid params (without password)" do
      it "updates the user" do
        patch user_path(user), params: {
          user: {
            name: "Updated Name",
            email: "updated@example.com"
          }
        }
        user.reload
        expect(user.name).to eq("Updated Name")
        expect(user.email).to eq("updated@example.com")
      end

      it "redirects to edit page with success message" do
        patch user_path(user), params: {
          user: {
            name: "Updated Name",
            email: "updated@example.com"
          }
        }
        expect(response).to redirect_to(edit_user_path(user))
        expect(flash[:success]).to eq("✅ プロフィールを更新しました")
      end
    end

    context "with valid params (with password)" do
      it "updates the password" do
        patch user_path(user), params: {
          user: {
            password: "newpassword",
            password_confirmation: "newpassword"
          }
        }
        user.reload
        expect(user.authenticate("newpassword")).to be_truthy
      end
    end

    context "with invalid params" do
      it "renders the edit template" do
        patch user_path(user), params: {
          user: {
            email: "" # 無効なメール
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end

    context "when trying to update another user" do
      it "redirects to root path" do
        patch user_path(other_user), params: {
          user: {
            name: "Hacked Name"
          }
        }
        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq("他のユーザーのプロフィールは編集できません")
      end
    end
  end
end
