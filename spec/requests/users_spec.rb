require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user) { create(:user) }

  describe 'ユーザーアカウント画面関連' do
    it 'ユーザーアカウント登録画面に遷移できること' do
      get new_user_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(I18n.t('activerecord.attributes.user.name'))
      expect(response.body).to include(I18n.t('activerecord.attributes.user.email'))
      expect(response.body).to include(I18n.t('activerecord.attributes.user.password'))
      expect(response.body).to include(I18n.t('activerecord.attributes.user.password_confirmation'))
    end

    it 'ユーザーアカウント詳細画面に遷移できず、ログイン画面に遷移すること' do
      get user_path(user)
      expect(response).to redirect_to(login_path)
    end

    it 'ユーザーアカウント編集画面に遷移できず、ログイン画面に遷移すること' do
      get edit_user_path(user)
      expect(response).to redirect_to(login_path)
    end
  end
end
