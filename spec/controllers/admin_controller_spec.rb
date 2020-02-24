require 'rails_helper'

RSpec.describe AdminController, type: :controller do

  describe "GET #index" do
    context "logged out user" do
      it "forwards user to login" do
        get :index
        expect(response.code).to eql "302"
      end
    end

    context "logged in user" do
      before do
        @user = create(:user)
        sign_in(@user)
      end

      it "log out non admin user" do
        get :index
        expect(response.code).to eql "302"
      end

      it "returns http success" do
        @user.update(admin: true)
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

end
