require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  it "is valid with a name and email" do
    expect(@user).to be_valid
  end

  it "is invalid with a blank name" do
    @user.name = "  "
    expect(@user).to be_invalid
  end

  it "is invalid with a blank email" do
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

  it "is valid with valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]
    aggregate_failures do
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid  
      end
    end
  end

  it "is invalid with invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com]
    aggregate_failures do
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).to be_invalid  
      end
    end
  end


end
