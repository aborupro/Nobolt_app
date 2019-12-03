require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let!(:user) { FactoryBot.create(:user) }

  describe "account_activation" do
    it "activates account" do
      user.activation_token = User.new_token
      mail = UserMailer.account_activation(user)
      expect(mail.subject).to eq("Nobologよりメールアドレスの確認")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
      expect(mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join).to include(user.name)
      expect(mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join).to include(user.activation_token)
      expect(mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join).to include(CGI.escape(user.email))
    end
  end

  describe "password_reset" do
    it "resets password" do
      user.reset_token = User.new_token
      mail = UserMailer.password_reset(user)
      expect(mail.subject).to eq("Nobologよりパスワード再設定のご案内")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
      expect(mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join).to include(user.name)
      expect(mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join).to include(user.reset_token)
      expect(mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join).to include(CGI.escape(user.email))
    end
  end

end
