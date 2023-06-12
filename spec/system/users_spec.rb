require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'アカウント登録ページ' do
    let(:user) { build(:user) }
    before { visit new_user_path }

    it '正常にアカウント登録できること' do
      fill_in 'ユーザー名', with: user.name
      fill_in 'メールアドレス（任意）', with: user.email
      fill_in 'パスワード', with: user.password
      fill_in 'パスワード（確認）', with: user.password_confirmation
      click_on '新規登録する'
      expect(page).to have_current_path(posts_path)
      expect(page).to have_content('アカウントを登録しました')
      expect(page).to have_content(user.name)
    end

    it '不適正な値で登録した場合、失敗すること' do
      fill_in 'ユーザー名', with: ''
      fill_in 'メールアドレス（任意）', with: ''
      fill_in 'パスワード', with: ''
      fill_in 'パスワード（確認）', with: ''
      click_on '新規登録する'
      expect(page).to have_content('登録に失敗しました。')
      expect(page).to have_content('ユーザー名 を入力してください')
      expect(page).to have_content('パスワード を入力してください')
    end

    it '不適正な値で登録した場合、失敗すること' do
      fill_in 'ユーザー名', with: 'aaaa'
      fill_in 'メールアドレス（任意）', with: user.email
      fill_in 'パスワード', with: 'aaaa'
      fill_in 'パスワード（確認）', with: 'aa'
      click_on '新規登録する'
      expect(page).to have_content('登録に失敗しました。')
      expect(page).to have_content('ユーザー名 は8文字以上で入力してください')
      expect(page).to have_content('パスワード は8文字以上で入力してください')
      expect(page).to have_content('パスワード は英数字と記号を含めて下さい')
      expect(page).to have_content('パスワード（確認） とパスワードが一致しません')
    end

    it 'ログインページに遷移できること' do
      click_on 'ログイン', class: 'link-text'
      expect(page).to have_current_path(login_path)
    end

    it 'ゲストログインできること' do
      click_on 'ゲストログイン', class: 'link-text'
      expect(page).to have_current_path(posts_path)
      expect(page).to have_content('ゲストユーザーとしてログインしました')
      expect(page).to have_content('guest_user')
    end
  end

  describe 'ユーザー詳細、編集ページ' do
    let(:user) { create(:user) }
    before { login(user) }

    it 'ユーザー詳細ページに遷移でき、適切な情報が表示されていること' do
      click_on user.name
      expect(page).to have_current_path(user_path(user))
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).not_to have_content(user.password)
    end

    it 'ユーザー編集ページに遷移でき、適切な情報が表示されていること' do
      click_on user.name
      click_on '変更する　＞'
      expect(page).to have_current_path(edit_user_path(user))
      expect(find('#user_name').value).to eq(user.name)
      expect(find('#user_email').value).to eq(user.email)
      expect(find('#user_password').value).to eq(nil)
      expect(find('#user_password_confirmation').value).to eq(nil)
    end

    it 'パスワードを入力せずともユーザー情報を更新できること' do
      visit edit_user_path(user)
      fill_in 'ユーザー名', with: 'baseball_user'
      fill_in 'メールアドレス（任意）', with: 'baseball_user@example.com'
      click_on '更新'
      expect(page).to have_current_path(user_path(user))
      expect(page).to have_content('ユーザー情報を更新しました')
      expect(page).to have_content('baseball_user')
      expect(page).to have_content('baseball_user@example.com')
    end

    it '戻るボタンを押下して、ユーザー詳細ページに戻れること' do
      visit edit_user_path(user)
      click_on '戻る'
      expect(page).to have_current_path(user_path(user))
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).not_to have_content(user.password)
    end

    it 'パスワードを変更できること' do
      visit edit_user_path(user)
      fill_in 'パスワード', with: 'password+1'
      fill_in 'パスワード（確認）', with: 'password+1'
      click_on '更新'
      expect(page).to have_current_path(user_path(user))
      click_on 'ログアウト'
      fill_in 'ユーザー名', with: user.name
      fill_in 'パスワード', with: 'password+1'
      click_on 'ログインする'
      expect(page).to have_current_path(posts_path)
      expect(page).to have_content('ログインしました')
      expect(page).to have_content(user.name)
    end
  end
end
