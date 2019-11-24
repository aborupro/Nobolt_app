require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do
  
  let(:user) { FactoryBot.create(:user) }

  def patch_invalid_information
    patch user_path(user), params: { 
      user: { 
        name:  "",
        email: "foo@invalid",
        password: "foo",
        password_confirmation: "bar" 
      }
    }
  end

  describe "GET /users/:id/edit" do
    it "is unsuccessful edit" do
      get edit_user_path(user)
      expect(request.fullpath).to eq "/users/1/edit"
      patch_invalid_information
      expect(request.fullpath).to eq "/users/1"
    end
  end
end
