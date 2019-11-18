require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  it "is valid with a name and an email" do
    expect(@user).to be_valid
  end

  it "is invalid without a name" do
    @user.name = "  "
    expect(@user).to be_invalid
  end

  it "is invalid without an email" do
    @user.email = "  "
    expect(@user).to be_invalid
  end

  it "is invalid with a too long name" do
    @user.name = "a" * 51
    expect(@user).to be_invalid
  end

  it "is invalid with a too long email" do
    @user.email = "a" * 244 + "@example.com"
    expect(@user).to be_invalid
  end


end
