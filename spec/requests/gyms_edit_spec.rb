require 'rails_helper'

RSpec.describe "GymsEdit", type: :request do

  let!(:gym) { FactoryBot.create(:gym) }
  let!(:other_gym) { FactoryBot.create(:gym) }
  let!(:user) { FactoryBot.create(:user) }

  def patch_valid_information
    patch gym_path(gym), params: { 
      gym: { 
        picture: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/factories/boulder1.jpg'), 'image/jpg'),
        url: "https://new_nobolog.com",
        business_hours: "10:00-24:00",
        price: "2200円"
      }
    }
  end

  def patch_invalid_information
    patch gym_path(gym), params: { 
      gym: { 
        picture: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/factories/over5MB.jpeg'), 'image/jpeg'),
        url: "aaaaa",
        business_hours: "",
        price: ""
      }
    }
  end

  describe "gym#edit" do
    context "patch valid information when logged in" do
      it "can update" do
        log_in_as(user)
        get edit_gym_path(gym)
        expect(request.fullpath).to eq edit_gym_path(gym)
        patch_valid_information
        expect(flash[:success]).to be_truthy
        expect(request.path).to eq edit_gym_path(gym)
        gym.reload
        expect(gym.picture.identifier).to eq "boulder1.jpg"
        expect(gym.url).to eq "https://new_nobolog.com"
        expect(gym.business_hours).to eq "10:00-24:00"
        expect(gym.price).to eq "2200円"
      end

      it "can access edit page with friendly forwarding and can update" do
        get edit_gym_path(gym)
        log_in_as(user)
        follow_redirect!
        expect(request.fullpath).to eq edit_gym_path(gym)
        patch_valid_information
        expect(flash[:success]).to be_truthy
        expect(request.fullpath).to eq edit_gym_path(gym)
        gym.reload
        expect(gym.picture.identifier).to eq "boulder1.jpg"
        expect(gym.url).to eq "https://new_nobolog.com"
        expect(gym.business_hours).to eq "10:00-24:00"
        expect(gym.price).to eq "2200円"
      end
    end

    context "patch invalid information when logged in" do
      it "cannot update" do
        log_in_as(user)
        get edit_gym_path(gym)
        expect(request.fullpath).to eq edit_gym_path(gym)
        patch_invalid_information
        expect(request.fullpath).to eq edit_gym_path(gym)
        gym.reload
        expect(gym.url).to eq "https://nobolog.com"
        expect(gym.business_hours).to eq "9:00-23:00"
        expect(gym.price).to eq "1800円"
      end
    end

    context "patch valid information when not logged in" do
      it "cannot update" do
        patch_valid_information
        expect(flash[:danger]).to_not be_empty
        follow_redirect!
        expect(request.fullpath).to eq login_path
      end
    end

    context "visits edit page when not logged in" do
      it "redirects to log in page" do
        get edit_user_path(gym)
        expect(flash[:danger]).to_not be_empty
        follow_redirect!
        expect(request.fullpath).to eq login_path
      end
    end

  end
end
