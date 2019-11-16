require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  let(:base_title) { "Nobolog" }

  describe "#home" do
    it "responds successfully" do
      get :home
      expect(response).to be_success
    end

    it "returns a 200 response" do
      get :home
      expect(response).to have_http_status "200"
    end

    
  end

  describe "#help" do
    it "responds successfully" do
      get :help
      expect(response).to be_success
    end

    it "returns a 200 response" do
      get :help
      expect(response).to have_http_status "200"
    end
  end

end
