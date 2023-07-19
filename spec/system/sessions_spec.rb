require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  let(:user) { create(:user) }

  describe 'ログインページ' do
    context '正常なログイン、ログアウトができること' do
      before do
        visit login_path
        fill_in 'ユーザー名', with: user.name
        fill_in 'パスワード', with: user.password
        click_on 'ログインする'
      end
      it '正常にログインし、観戦記録一覧ページに遷移できること' do
        expect(page).to have_content('ログインしました')
        expect(page).to have_content(user.name)
        expect(page).to have_current_path(games_path)
      end

      it 'ログアウトできること' do
        click_on 'ログアウト'
        expect(page).to have_content('ログアウトしました。')
        expect(page).to have_current_path(login_path)
      end
    end

    context '正常なゲストログイン、ログアウトができること' do
      before do
        visit login_path
        click_on 'ゲストログイン', class: 'link-text'
      end
      it 'ゲストログインができること' do
        expect(page).to have_content('ゲストユーザーとしてログインしました')
        expect(page).to have_content('guest_user')
        expect(page).to have_current_path(games_path)
      end
      it 'ゲストログインができること' do
        click_on 'ログアウト'
        expect(page).to have_content('ログアウトしました。')
        expect(page).to have_current_path(login_path)
      end
    end

    context 'ログアウト後に、ログインが必要なページに遷移できないこと' do
      before do
        visit login_path
        fill_in 'ユーザー名', with: user.name
        fill_in 'パスワード', with: user.password
        click_on 'ログインする'
        click_on 'ログアウト'
      end

      it '新規投稿ページに遷移できないこと' do
        visit new_post_path
        expect(page).to have_current_path(login_path)
      end

      it '思い出一覧ページに遷移できないこと' do
        visit my_posts_path
        expect(page).to have_current_path(login_path)
      end

      it '観戦記録新規作成ページに遷移できないこと' do
        visit new_game_path
        expect(page).to have_current_path(login_path)
      end

      it '観戦記録一覧ページに遷移できないこと' do
        visit games_path
        expect(page).to have_current_path(login_path)
      end

      it 'ユーザー情報確認ページに遷移できないこと' do
        visit user_path(user)
        expect(page).to have_current_path(login_path)
      end

      it 'ユーザー編集ページに遷移できないこと' do
        visit edit_user_path(user)
        expect(page).to have_current_path(login_path)
      end
    end

    context '異常な値でログインした場合、失敗すること' do
      before { visit login_path }

      it '無効なユーザー名でログインした際、ログインに失敗してログインページにリダイレクトすること' do
        fill_in 'ユーザー名', with: user.name + '1'
        fill_in 'パスワード', with: user.password
        click_on 'ログインする'
        expect(page).to have_content('ログインに失敗しました。ユーザー名、またはパスワードが違います。')
        expect(page).to have_current_path(login_path)
      end

      it '無効なユーザー名でログインした際、ログインに失敗してログインページにリダイレクトすること' do
        fill_in 'ユーザー名', with: user.name
        fill_in 'パスワード', with: user.password + '1'
        click_on 'ログインする'
        expect(page).to have_content('ログインに失敗しました。ユーザー名、またはパスワードが違います。')
        expect(page).to have_current_path(login_path)
      end

      it '入力欄が空の状態でログインした際、、ログインに失敗してログインページにリダイレクトすること' do
        fill_in 'ユーザー名', with: ''
        fill_in 'パスワード', with: ''
        click_on 'ログインする'
        expect(page).to have_content('ログインに失敗しました。ユーザー名、またはパスワードが違います。')
        expect(page).to have_current_path(login_path)
      end
    end

    it 'アカウント登録ページに遷移できること' do
      visit login_path
      click_on 'アカウント登録'
      expect(page).to have_current_path(new_user_path)
    end
  end
end
