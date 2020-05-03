require 'rails_helper'

RSpec.describe "Gyms", type: :request do

  let!(:user) { FactoryBot.create(:user) }
  let!(:admin_user) { FactoryBot.create(:user, admin: true) }
  let!(:gym) { FactoryBot.create(:gym) }

  describe "gym" do
    context "create" do
      it "does not create when not logged in" do
        expect{
          post gyms_path, params: {gym: { 
                                        name: "Gym 1",
                                        prefecture_code: 13,
                                        picture: "MyString",
                                        url: "https://nobolog.com",
                                        business_hours: "MyString",
                                        address: "MyString",
                                        price: "MyString"
                                      } 
          }
        }.to_not change(Gym, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
    end
    
    context "destroy" do
      it "does not destroy when not logged in" do
        expect{
          delete gym_path(gym)
        }.to_not change(Gym, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
  
      it "does not destroy when logged in as a non-admin" do
        log_in_as(user)
        expect{
          delete gym_path(gym)
        }.to_not change(Gym, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/gyms'
      end

      it "destroy when logged in as an admin-user" do
        log_in_as(admin_user)
        expect {
          delete gym_path(gym)
        }.to change(Gym, :count).by(-1)
        follow_redirect!
        expect(request.fullpath).to eq '/gyms'
      end
    end
  end
end
