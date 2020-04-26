require 'rails_helper'

RSpec.describe "Records", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  let!(:record) { FactoryBot.create(:record, user: user) }
  let!(:other_record) { FactoryBot.create(:record, user: other_user) }

  let!(:gym) { FactoryBot.create(:gym) }

  describe "GET /records" do
    context "create" do
      it "does not create a record when not logged in" do
        expect{
          post records_path, params: {record: { 
                                        grade: "grade 1",
                                        strong_point: "MyString",
                                        problem_id: "problem_id 1",
                                        picture: "MyString",
                                        gym_name: Gym.first.name
                                      } 
          }
        }.to_not change(Record, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
    end
    
    context "destroy" do
      it "does not destroy a record when not logged in" do
        expect{
          delete record_path(record)
        }.to_not change(Record, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
  
      it "does not destroy other user's record" do
        log_in_as(user)
        expect{
          delete record_path(other_record)
        }.to_not change(Record, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end
    end
  end
end
