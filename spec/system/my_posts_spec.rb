require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:post1) { create(:post, user: user1) }
  let!(:post2) { create(:post, user: user2) }
  let!(:baseball_team1) { create(:baseball_team, name: 'Team1') }
  let!(:baseball_park1) { create(:baseball_park, name: 'Park1') }
  let!(:category1) { create(:category, name: 'Category1') }
  before do
    login(user1)
    click_on '思い出一覧'
  end

  describe '思い出一覧' do
    it '投稿一覧に遷移できること' do
      expect(page).to have_current_path(my_posts_path)
    end

    it 'ログインユーザーの投稿が表示されていること' do
      expect(page).to have_content(post1.title)
    end

    it 'ログインユーザー以外の投稿が表示されていないこと' do
      expect(page).not_to have_content(post2.title)
    end
  end

  describe '投稿詳細ページ' do
    it '投稿詳細ページに遷移できること' do
      click_on post1.title
      expect(page).to have_current_path(my_post_path(post1))
      expect(page).to have_content(post1.title)
      expect(page).to have_content('一覧に戻る')
      expect(page).to have_content('変更する')
      expect(page).to have_content('削除する')
    end

    it '投稿詳細ページに遷移後、戻るボタンで一覧に戻れること' do
      click_on post1.title
      click_on '一覧に戻る'
      expect(page).to have_current_path(my_posts_path)
    end

    it '投稿を削除できること' do
      click_on post1.title
      click_on '削除する'
      expect(page).to have_current_path(my_posts_path)
      expect(page).to have_content("投稿「#{post1.title}」を削除しました")
    end
  end

  describe '投稿編集ページ' do
    it '投稿編集ページに遷移できること' do
      click_on post1.title
      click_on '変更する'
      expect(page).to have_current_path(edit_my_post_path(post1))
      expect(find('#post_title').value).to eq(post1.title)
      expect(find('#post_baseball_team_id').value).to eq(post1.baseball_team_id.to_s)
      expect(find('#post_baseball_park_id').value).to eq(post1.baseball_park_id.to_s)
      expect(find('#post_category_id').value).to eq(post1.category_id.to_s)
      expect(find('#post_content').value).to eq(post1.content)
    end

    it '投稿を編集できること' do
      # 投稿編集ページに遷移
      visit edit_my_post_path(post1)
      # 投稿を編集
      fill_in 'タイトル', with: 'post_test_title'
      select 'Team1', from: 'チーム'
      select 'Park1', from: '球場'
      select 'Category1', from: 'カテゴリー'
      fill_in '投稿内容', with: 'post_test_content'
      click_on '投稿する'
      # 投稿詳細に遷移
      expect(page).to have_current_path(my_post_path(post1))
      expect(page).to have_content('post_test_title')
      expect(page).to have_content('Team1')
      expect(page).to have_content('Park1')
      expect(page).to have_content('Category1')
      expect(page).to have_content('post_test_content')
    end
  end
end
