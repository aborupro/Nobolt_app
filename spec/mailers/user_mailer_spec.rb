require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:mail) { UserMailer.account_activation }
    let!(:user) { FactoryBot.create(:user) }

    it "activate account" do
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

  # describe "password_reset" do
  #   let(:mail) { UserMailer.password_reset }

  #   it "renders the headers" do
  #     expect(mail.subject).to eq("Password reset")
  #     expect(mail.to).to eq(["to@example.org"])
  #     expect(mail.from).to eq(["noreply@example.com"])
  #   end

  #   it "renders the body" do
  #     expect(mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join).to include("Hi")
  #   end
  # end

end
