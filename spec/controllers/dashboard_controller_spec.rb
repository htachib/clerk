require 'rails_helper'

RSpec.describe DashboardController, type: :controller do

  describe "GET #index" do
    context "logged out user" do
      it "forwards user to login" do
        get :index
        expect(response.code).to eql "302"
      end
    end

    context "logged in user" do
      before do
        sign_in(create(:user))
      end

      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

end
