require 'rails_helper'

RSpec.describe Grade, type: :model do
  let!(:grade) { FactoryBot.build(:grade) }
  let!(:other_grade) { FactoryBot.build(:grade) }

  describe "grade" do
    context "can save" do
      it "is valid" do
        expect(grade).to be_valid
      end
    end

    context "cannot save" do
      it "is invalid with a blank name" do
        grade.name = "　"
        grade.valid?
        expect(grade.errors[:name]).to include('を入力してください')
      end

      it "is invalid with a duplicate name" do
        grade.name = "3級"
        other_grade.name = "3級"
        grade.save
        other_grade.valid?
        expect(other_grade.errors[:name]).to include('はすでに存在します')
      end
    end
  end
end
