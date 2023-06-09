module LoginHelper
  def login(user)
    visit login_path
    fill_in 'ユーザー名', with: user.name
    fill_in 'パスワード', with: user.password
    click_on 'ログインする'
  end
end
