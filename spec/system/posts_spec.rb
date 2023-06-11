require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  describe 'トップページの表示' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let!(:post1) { create(:post, user: user1) }
    let!(:post2) { create(:post, user: user2) }
    before { visit root_path }

    it 'トップページに全ユーザーの投稿が表示されていること' do
      expect(page).to have_current_path(root_path)
      expect(page).to have_content(post1.title)
      expect(page).to have_content(post2.title)
    end

    it 'タイトル押下時に投稿詳細画面に遷移すること' do
      click_on post1.title
      expect(page).to have_current_path(post_path(post1))
      expect(page).to have_content(post1.title)
      expect(page).to have_content(post1.content)
    end

    it '検索フォームが正しく表示されること' do
      expect(page).to have_field('q_title_cont')
      expect(page).to have_field('q_baseball_team_id_eq')
      expect(page).to have_field('q_baseball_park_id_eq')
      expect(page).to have_field('q_category_id_eq')
      expect(page).to have_button('検索')
    end
  end

  describe 'トップページの検索機能' do
    let!(:baseball_team1) { create(:baseball_team, name: 'Team1') }
    let!(:baseball_team2) { create(:baseball_team, name: 'Team2') }
    let!(:baseball_park1) { create(:baseball_park, name: 'Park1') }
    let!(:baseball_park2) { create(:baseball_park, name: 'Park2') }
    let!(:category1) { create(:category, name: 'Category1') }
    let!(:category2) { create(:category, name: 'Category2') }
    let!(:post1) { create(:post, title: 'Post1', baseball_team: baseball_team1, baseball_park: baseball_park1, category: category1) }
    let!(:post2) { create(:post, title: 'Post2', baseball_team: baseball_team2, baseball_park: baseball_park2, category: category2) }
    let!(:post3) { create(:post, title: 'Post3', baseball_team: baseball_team1, baseball_park: baseball_park1, category: category1) }
    before { visit root_path }

    it 'タイトルの検索が正しく機能すること' do
      fill_in 'タイトル', with: 'Post1'
      click_button '検索'
      expect(page).to have_content('Post1')
      expect(page).not_to have_content('Post2')
      expect(page).not_to have_content('Post3')
    end

    it 'チームの検索が正しく機能すること' do
      select 'Team1', from: 'チーム'
      click_button '検索'
      expect(page).to have_content('Post1')
      expect(page).to have_content('Post3')
      expect(page).not_to have_content('Post2')
    end

    it '球場の検索が正しく機能すること' do
      select 'Park1', from: '球場'
      click_button '検索'
      expect(page).to have_content('Post1')
      expect(page).to have_content('Post3')
      expect(page).not_to have_content('Post2')
    end

    it 'カテゴリーの検索が正しく機能すること' do
      select 'Category1', from: 'カテゴリー'
      click_button '検索'
      expect(page).to have_content('Post1')
      expect(page).to have_content('Post3')
      expect(page).not_to have_content('Post2')
    end
  end

  describe '投稿する' do
    let(:user) { create(:user) }
    let!(:baseball_team) { create(:baseball_team, name: 'Team') }
    let!(:baseball_park) { create(:baseball_park, name: 'Park') }
    let!(:category) { create(:category, name: 'Category') }
    before do
      login(user)
      visit new_post_path
    end

    it '正常な値で投稿する' do
      # 入力欄に入力して投稿
      fill_in 'タイトル', with: 'post_test_title'
      select 'Team', from: 'チーム'
      select 'Park', from: '球場'
      select 'Category', from: 'カテゴリー'
      fill_in '投稿内容', with: 'post_test_content'
      attach_file('post_photo', Rails.root.join('spec/images/test_image.jpg'))
      click_on '投稿する'
      # 投稿一覧に遷移
      expect(page).to have_current_path(posts_path)
      expect(page).to have_content('post_test_title')
      expect(page).to have_content('Team')
      expect(page).to have_content('Park')
      expect(page).to have_content('Category')
      expect(page).to have_css("img[src*='test_image.jpg']")
    end

    it '空値で投稿する' do
      click_on '投稿する'
      expect(page).to have_content('投稿に失敗しました。')
      expect(page).to have_content('タイトル を入力してください')
      expect(page).to have_content('投稿内容 を入力してください')
      expect(page).to have_content('写真 を入力してください')
      expect(page).to have_content('チーム は必須です')
      expect(page).to have_content('球場 は必須です')
      expect(page).to have_content('カテゴリー は必須です')
    end

    it '空値で投稿する' do
      fill_in 'タイトル', with: 'x' * 81
      fill_in '投稿内容', with: 'x' * 1001
      click_on '投稿する'
      expect(page).to have_content('投稿に失敗しました。')
      expect(page).to have_content('タイトル は80文字以下で入力してください')
      expect(page).to have_content('投稿内容 は1000文字以下で入力してください')
    end

  end
end
