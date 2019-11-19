require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: "Example User", email: "user@example.com",
              password: "foobar", password_confirmation: "foobar")
  end

  it "is valid with a name and email" do
    expect(@user).to be_valid
  end

  describe "name" do
    it "is invalid with a blank name" do
      @user.name = "  "
      expect(@user).to be_invalid
    end

    it "is invalid with a too long name" do
      @user.name = "a" * 51
      expect(@user).to be_invalid
    end
  end

  describe "email" do
    it "is invalid with a blank email" do
      @user.email = "  "
      expect(@user).to be_invalid
    end

    context "maximum character length is 255" do
      it "is valid with a not too long email" do
        @user.email = "a" * 243 + "@example.com"
        expect(@user).to be_valid
      end

      it "is invalid with a too long email" do
        @user.email = "a" * 244 + "@example.com"
        expect(@user).to be_invalid
      end
    end

    context "email should have valid email addresses" do
      it "is valid with valid addresses" do
        aggregate_failures do
          @user.email = "user@example.com"
          expect(@user).to be_valid
  
          @user.email = "USER@foo.COM"
          expect(@user).to be_valid
  
          @user.email = "A_US-ER@foo.bar.org"
          expect(@user).to be_valid
  
          @user.email = "first.last@foo.jp"
          expect(@user).to be_valid
  
          @user.email = "alice+bob@baz.cn"
          expect(@user).to be_valid
        end
      end
  
      it "is invalid with invalid addresses" do
        aggregate_failures do
          @user.email = "user@example,com"
          expect(@user).to be_invalid
  
          @user.email = "user_at_foo.org"
          expect(@user).to be_invalid
  
          @user.email = "user.name@example."
          expect(@user).to be_invalid
  
          @user.email = "foo@bar_baz.com"
          expect(@user).to be_invalid
  
          @user.email = "foo@bar+baz.com"
          expect(@user).to be_invalid
        end
      end
    end

    it "is unique email addresses" do
      duplicate_user = @user.dup
      duplicate_user.email = @user.email.upcase
      @user.save
      expect(duplicate_user).to be_invalid
    end

    it "is saved as lower-case email addresses" do
      @user.email = "Foo@ExAMPle.CoM"
      @user.save
      expect(@user.reload.email).to eq 'foo@example.com'
    end
  end

  it "should be present(nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    expect(@user).to be_invalid
  end

  context "mimimum password length is 6" do
    it "is mimimum length password" do
      @user.password = @user.password_confirmation = "a" * 6
      expect(@user).to be_valid
    end

    it "is less than mimimum password length" do
      @user.password = @user.password_confirmation = "a" * 5
      expect(@user).to be_invalid
    end
  end

end
