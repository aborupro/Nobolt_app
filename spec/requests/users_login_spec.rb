require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  #is_logged_in?メソッドを使えるようにするために、呼び出す
  include SessionsHelper

  let(:user) { FactoryBot.create(:user) }

  def post_invalid_information
    post login_path, params: {
      session: {
        email: "",
        password: ""
      }
    }
  end

  def post_valid_information
    post login_path, params: {
      session: {
        email: user.email,
        password: user.password
      }
    }
  end

  describe "GET /login" do
    context "invalid form information" do
      it "post invalid information and has dager message then delete danger message" do
        get login_path
        post_invalid_information
        expect(flash[:danger]).to be_truthy
        expect(is_logged_in?).to be_falsey
        get root_path
        expect(flash[:danger]).to be_falsey
      end
    end

    context "valid form information" do
      it "post valid information and has no danger message folloed by twice logout" do
        get login_path
        post_valid_information
        expect(flash[:danger]).to be_falsey
        expect(is_logged_in?).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/users/1'
        delete logout_path
        expect(is_logged_in?).to be_falsey
        follow_redirect!
        expect(request.fullpath).to eq '/'
        delete logout_path
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end
    end
  end
end
