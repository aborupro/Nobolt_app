require 'rails_helper'

RSpec.describe 'UsersEdits', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user) }
  let!(:admin_user) { FactoryBot.create(:user, admin: true) }

  def patch_valid_information
    patch user_path(user), params: {
      user: {
        name: 'Foo Bar',
        email: 'foo@bar.com',
        password: '',
        password_confirmation: '',
        picture: "#{Rails.root}/spec/factories/boulder1.jpg"
      }
    }
  end

  def patch_invalid_information
    patch user_path(user), params: {
      user: {
        name: '',
        email: 'foo@invalid',
        password: 'foo',
        password_confirmation: 'bar',
        picture: "#{Rails.root}/spec/factories/over5MB.jpeg"
      }
    }
  end

  describe 'GET /users/:id/edit' do
    context 'edit' do
      it 'is unsuccessful edit' do
        log_in_as(user)
        get edit_user_path(user)
        expect(request.fullpath).to eq edit_user_path(user)
        patch_invalid_information
        expect(request.fullpath).to eq user_path(user)
      end

      it 'is successful edit' do
        log_in_as(user)
        get edit_user_path(user)
        expect(request.fullpath).to eq edit_user_path(user)
        patch_valid_information
        expect(flash[:success]).to be_truthy
        expect(request.fullpath).to eq user_path(user)
        user.reload
        expect(user.name).to eq 'Foo Bar'
        expect(user.email).to eq 'foo@bar.com'
      end

      it 'is successful edit with friendly forwarding' do
        get edit_user_path(user)
        log_in_as(user)
        follow_redirect!
        expect(request.fullpath).to eq edit_user_path(user)
        patch_valid_information
        expect(flash[:success]).to be_truthy
        expect(request.fullpath).to eq user_path(user)
        user.reload
        expect(user.name).to eq 'Foo Bar'
        expect(user.email).to eq 'foo@bar.com'
      end

      it 'edit when not logged in' do
        get edit_user_path(user)
        expect(flash[:danger]).to_not be_empty
        follow_redirect!
        expect(request.fullpath).to eq login_path
      end

      it 'edit when not logged in as wrong user' do
        log_in_as(other_user)
        get edit_user_path(user)
        expect(flash[:danger]).to be_falsey
        follow_redirect!
        expect(request.fullpath).to eq root_path
      end

      it "doesn't allow the admin attribute to be edited via the web" do
        log_in_as(other_user)
        expect(other_user.admin?).to be_falsey
        patch user_path(other_user), params: {
          user: {
            password: other_user.password,
            password_confirmation: other_user.password,
            admin: true
          }
        }
        expect(other_user.reload.admin?).to be_falsey
      end
    end

    context 'update' do
      it 'when not logged in' do
        patch_valid_information
        expect(flash[:danger]).to_not be_empty
        follow_redirect!
        expect(request.fullpath).to eq login_path
      end

      it 'when logged in as wrong user' do
        log_in_as(other_user)
        patch_valid_information
        expect(flash[:danger]).to be_falsey
        follow_redirect!
        expect(request.fullpath).to eq root_path
      end
    end

    context 'index' do
      it 'when not logged in' do
        get users_path
        follow_redirect!
        expect(request.fullpath).to eq login_path
      end
    end

    context 'destroy' do
      it 'when not logged in' do
        expect do
          delete user_path(user)
        end.to_not change(User, :count)
        follow_redirect!
        expect(request.fullpath).to eq login_path
      end

      it 'destroy when logged in as a non-admin' do
        log_in_as(other_user)
        expect do
          delete user_path(user)
        end.to_not change(User, :count)
        follow_redirect!
        expect(request.fullpath).to eq root_path
      end

      it 'destroy when logged in as an admin-user' do
        log_in_as(admin_user)
        expect do
          delete user_path(user)
        end.to change(User, :count).by(-1)
        follow_redirect!
        expect(request.fullpath).to eq users_path
      end
    end
  end
end
