require 'rails_helper'

RSpec.describe 'Games', type: :request do
  let!(:game) { create(:game) }

  describe '観戦記録関連画面' do
    it '観戦記録一覧画面に遷移できず、ログイン画面に遷移すること' do
      get games_path
      expect(response).to redirect_to(login_path)
    end

    it '観戦記録新規登録に遷移できず、ログイン画面に遷移すること' do
      get new_game_path
      expect(response).to redirect_to(login_path)
    end

    it '観戦記録詳細画面に遷移できず、ログイン画面に遷移すること' do
      get game_path(game)
      expect(response).to redirect_to(login_path)
    end

    it '観戦記録編集画面に遷移できず、ログイン画面に遷移すること' do
      get edit_game_path(game)
      expect(response).to redirect_to(login_path)
    end
  end
end
