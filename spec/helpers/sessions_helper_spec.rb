require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { create(:user) }

  describe "#log_in" do
    it "sets the user_id in the session" do
      helper.log_in(user)
      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe "#current_user" do
    context "when user is logged in" do
      before do
        session[:user_id] = user.id
      end

      it "returns the current user" do
        expect(helper.current_user).to eq(user)
      end

      it "caches the current user" do
        helper.current_user
        expect(User).not_to receive(:find_by)
        helper.current_user
      end
    end

    context "when user is not logged in" do
      it "returns nil" do
        expect(helper.current_user).to be_nil
      end
    end
  end

  describe "#logged_in?" do
    context "when user is logged in" do
      before do
        session[:user_id] = user.id
      end

      it "returns true" do
        expect(helper.logged_in?).to be true
      end
    end

    context "when user is not logged in" do
      it "returns false" do
        expect(helper.logged_in?).to be false
      end
    end
  end

  describe "#log_out" do
    before do
      session[:user_id] = user.id
    end

    it "deletes the user_id from the session" do
      helper.log_out
      expect(session[:user_id]).to be_nil
    end

    it "sets current_user to nil" do
      helper.log_out
      expect(helper.instance_variable_get(:@current_user)).to be_nil
    end
  end
end
