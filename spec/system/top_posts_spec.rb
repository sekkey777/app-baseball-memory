require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  describe 'ログイン前のトップページの表示' do
    before { visit root_path }

    it 'ログイン前に表示されるべきボタンが表示されていること' do
      expect(page).to have_content('新規登録して観戦記録をつける')
      expect(page).to have_content('ログインはこちら')
      expect(page).to have_content('ゲストログインはこちら')
    end

    it '「新規登録して観戦記録をつける」が正常に機能していること' do
      click_on '新規登録して観戦記録をつける'
      expect(page).to have_current_path(new_user_path)
    end

    it '「ログインはこちら」が正常に機能していること' do
      click_on 'ログインはこちら'
      expect(page).to have_current_path(login_path)
    end

    it '「ログインはこちら」が正常に機能していること' do
      click_on 'ゲストログインはこちら'
      expect(page).to have_content('ゲストユーザーとしてログインしました')
      expect(page).to have_content('guest_user')
      expect(page).to have_current_path(games_path)
    end
  end

  describe 'ログイン後のトップページの表示' do
    let(:user) { create(:user) }
    before do
      login(user)
      visit root_path
    end

    it 'ログイン後に表示されるべきボタンが表示されていること' do
      within '.bg-image' do
        expect(page).to have_content('思い出を投稿する')
        expect(page).to have_content('観戦記録をつける')
      end
    end

    it '「思い出を投稿する」が正常に機能していること' do
      within '.bg-image' do
        click_on '思い出を投稿する'
        expect(page).to have_current_path(new_post_path)
      end
    end

    it '「観戦記録をつける」が正常に機能していること' do
      within '.bg-image' do
        click_on '観戦記録をつける'
        expect(page).to have_current_path(new_game_path)
      end
    end

  end
end
