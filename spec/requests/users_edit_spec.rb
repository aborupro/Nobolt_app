require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do
  
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:other_user) }

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

  def patch_valid_information
    patch user_path(user), params: { 
      user: { 
        name:  "Foo Bar",
        email: "foo@bar.com",
        password: "",
        password_confirmation: "" 
      }
    }
  end

  describe "GET /users/:id/edit" do
    it "is unsuccessful edit" do
      log_in_as(user)
      get edit_user_path(user)
      expect(request.fullpath).to eq "/users/1/edit"
      patch_invalid_information
      expect(request.fullpath).to eq "/users/1"
    end

    it "is successful edit" do
      log_in_as(user)
      get edit_user_path(user)
      expect(request.fullpath).to eq "/users/1/edit"
      patch_valid_information
      expect(flash[:success]).to be_truthy
      expect(request.fullpath).to eq "/users/1"
      user.reload
      expect(user.name).to eq "Foo Bar"
      expect(user.email).to eq "foo@bar.com"
    end

    context "redirect" do
      it "edit when not logged in" do
        get edit_user_path(user)
        expect(flash[:danger]).to_not be_empty
        follow_redirect!
        expect(request.fullpath).to eq login_path
      end

      it "update when not logged in" do
        patch_valid_information
        expect(flash[:danger]).to_not be_empty
        follow_redirect!
        expect(request.fullpath).to eq login_path
      end

      it "edit when not logged in as wrong user" do
        log_in_as(other_user)
        get edit_user_path(user)
        expect(flash[:danger]).to be_falsey
        follow_redirect!
        expect(request.fullpath).to eq root_path
      end

      it "update when not logged in as wrong user" do
        log_in_as(other_user)
        patch_valid_information
        expect(flash[:danger]).to be_falsey
        follow_redirect!
        expect(request.fullpath).to eq root_path
      end
    end

    it "is successful edit with friendly forwarding" do
      get edit_user_path(user)
      log_in_as(user)
      follow_redirect!
      expect(request.fullpath).to eq edit_user_path(user)
      patch_valid_information
      expect(flash[:success]).to be_truthy
      expect(request.fullpath).to eq "/users/1"
      user.reload
      expect(user.name).to eq "Foo Bar"
      expect(user.email).to eq "foo@bar.com"
    end
  end
end
