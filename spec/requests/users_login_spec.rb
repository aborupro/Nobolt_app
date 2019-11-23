require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do

  def post_invalid_information
    post login_path, params: {
      session: {
        email: "",
        password: ""
      }
    }
  end

  describe "GET /login" do
    context "invalid form information" do
      it "post invalid information and delete danger message" do
        get login_path
        post_invalid_information
        expect(flash[:danger]).to be_truthy
        get root_path
        expect(flash[:danger]).to be_falsey
      end
    end
  end
end
