require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'ログインページに遷移する' do
    before do
      get login_path
    end
    it 'ログインページに遷移できること' do
      expect(response).to have_http_status(:success)
    end
    it '適切な文字が表示されていること' do
      expect(response.body).to include('ログイン')
      expect(response.body).to include('ユーザー名')
      expect(response.body).to include('パスワード')
      expect(response.body).to include('ログインする')
    end
  end

  describe '正常な値でログインする' do
    before do
      post login_path, params: { session: { name: user.name, password: user.password } }
    end

    it 'ログインできて、投稿一覧に遷移すること' do
      expect(response).to redirect_to(posts_path)
    end
    it 'session[:user_id]に値があること' do
      expect(session[:user_id]).not_to be_nil
    end
    it 'ログイン後にフラッシュメッセージが表示され、次の画面遷移時には表示されないこと' do
      follow_redirect!
      expect(response.body).to include('ログインしました。')
      get root_path
      expect(response.body).not_to include('ログインしました。')
    end
  end

  describe '異常な値でログインする' do
    context 'ログインできず、ログインページにリダイレクトすること' do
      it 'ユーザー名が不正' do
        user.name = 'test1234'
        post login_path, params: { session: { name: user.name, password: user.password } }
        expect(response).to render_template('new')
      end
      it 'パスワードが不正' do
        user.password = 'test1234'
        post login_path, params: { session: { name: user.name, password: user.password } }
        expect(response).to render_template('new')
      end
      it '適正なフラッシュメッセージが表示されること' do
        user.password = 'test1234'
        post login_path, params: { session: { name: user.name, password: user.password } }
        expect(flash[:danger]).to eq("ログインに失敗しました。ユーザー名、またはパスワードが違います。")
      end
    end
  end

  describe 'ログアウトする' do
    before do
      post login_path, params: { session: { name: user.name, password: user.password } }
      delete logout_path
    end
    it '正常にログアウトできること' do
      expect(response).to redirect_to(login_path)
      expect(controller).to_not be_logged_in
    end
    it '適正なフラッシュメッセージが表示されること' do
      expect(flash[:success]).to eq('ログアウトしました。')
    end
  end

  describe 'ゲストユーザーでログインする' do
    before do
      post login_path, params: { guest_login: true }
    end
    it 'ゲストユーザーでログインできること' do
      expect(response).to redirect_to(posts_path)
    end
    it '適正なフラッシュメッセージが表示されること' do
      expect(flash[:success]).to eq('ゲストユーザーとしてログインしました')
    end

    it 'guest_userが生成されていること' do
      guest_user = User.find_by(name: 'guest_user')
      expect(guest_user).not_to be_nil
      expect(guest_user.email).to include('@appbaseballmemory.com')
    end
  end
end
