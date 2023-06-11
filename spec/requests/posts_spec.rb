require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe '投稿関連画面への遷移' do
    let!(:post) { create(:post) }

    it 'ホーム画面に遷移できること' do
      get root_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(post.user.name)
      expect(response.body).to include(post.updated_at.strftime('%Y/%m/%d %H:%M:%S'))
      expect(response.body).to include(post.title)
      expect(response.body).to include(post.baseball_team.name)
      expect(response.body).to include(post.baseball_park.name)
      expect(response.body).to include(post.category.name)
    end

    it '投稿一覧画面に遷移できること' do
      get posts_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(post.user.name)
      expect(response.body).to include(post.updated_at.strftime('%Y/%m/%d %H:%M:%S'))
      expect(response.body).to include(post.title)
      expect(response.body).to include(post.baseball_team.name)
      expect(response.body).to include(post.baseball_park.name)
      expect(response.body).to include(post.category.name)
    end

    it '新規投稿画面に遷移できずに、ログイン画面に遷移すること' do
      get new_post_path
      expect(response).to redirect_to(login_path)
    end

    it '投稿詳細画面に遷移できること' do
      get post_path(post)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(post.user.name)
      expect(response.body).to include(post.updated_at.strftime('%Y/%m/%d %H:%M:%S'))
      expect(response.body).to include(post.title)
      expect(response.body).to include(post.content)
      expect(response.body).to include(post.baseball_team.name)
      expect(response.body).to include(post.baseball_park.name)
      expect(response.body).to include(post.category.name)
    end

    it '投稿編集画面に遷移できずに、ログイン画面に遷移すること' do
      get edit_my_post_path(post)
      expect(response).to redirect_to(login_path)
    end
  end

  describe 'トップページに表示される投稿の数が制御されていること' do
    let!(:post) { create_list(:post, 11) }

    it 'トップページに表示される投稿の最大数が10であること' do
      get root_path
      expect(assigns(:posts).count).to eq(10)
    end
  end
end
