require 'rails_helper'

RSpec.describe 'Applications', type: :system do
  let(:user) { create(:user) }

  describe 'ヘッダー' do
    context 'ログイン前のヘッダーボタンが正常に機能すること' do
      before do
        visit login_path
        click_on 'ホーム'
      end
      it 'トップページに遷移できること' do
        expect(page).to have_current_path(root_path)
      end

      it '投稿一覧ページに遷移できること' do
        click_on '投稿'
        expect(page).to have_current_path(posts_path)
      end

      it 'ログインページに遷移できること' do
        click_on 'ログイン'
        expect(page).to have_current_path(login_path)
      end

      it 'ゲストログインできること' do
        click_on 'ゲストログイン'
        expect(page).to have_current_path(posts_path)
        expect(page).to have_content('ゲストユーザーとしてログインしました')
      end

      it '新規登録ページに遷移ること' do
        click_on '新規登録'
        expect(page).to have_current_path(new_user_path)
      end
    end

    context 'ログイン後のヘッダーボタンが正常に機能すること' do
      before { login(user) }
      it '思い出投稿ページに遷移できること' do
        click_on '思い出を投稿'
        expect(page).to have_current_path(new_post_path)
      end

      it '思い出一覧ページに遷移でること' do
        click_on '思い出一覧'
        expect(page).to have_current_path(my_posts_path)
      end

      it '観戦記録投稿ページに遷移できること' do
        click_on '観戦記録をつける'
        expect(page).to have_current_path(new_game_path)
      end

      it '観戦記録一覧ページに遷移できること' do
        click_on '観戦記録一覧'
        expect(page).to have_current_path(games_path)
      end

      it 'ユーザー詳細ページに遷移できること' do
        click_on user.name
        expect(page).to have_current_path(user_path(user))
      end
    end
  end
end
