require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  describe 'ページネーションが機能していること' do
    let!(:post) { create_list(:post, 25) }
    before { visit root_path }
  
    it 'トップページに表示される投稿の最大数が10であること' do
      expect(page).to have_selector('div#test-post', count: 10)
    end

    it '3ページ目に最後の5件が表示されること' do
      click_on '3'
      expect(page).to have_selector('div#test-post', count: 5)
    end

    it 'Next押下時に次ページに遷移できること' do
      click_on 'Next'
      expect(page).to have_selector('div#test-post', count: 10)
      click_on 'Next'
      expect(page).to have_selector('div#test-post', count: 5)
    end

    it 'Last押下時に最後のページに遷移できること' do
      click_on 'Last'
      expect(page).to have_selector('div#test-post', count: 5)
      expect(page).not_to have_content('Next')
      expect(page).not_to have_content('Last')
    end

    it 'Previous押下時に前ページに遷移できること' do
      click_on 'Last'
      expect(page).to have_selector('div#test-post', count: 5)
      click_on 'Previous'
      expect(page).to have_selector('div#test-post', count: 10)
      click_on 'Previous'
      expect(page).to have_selector('div#test-post', count: 10)
      expect(page).not_to have_content('First')
      expect(page).not_to have_content('Previous')
    end

    it 'First押下時に最初のページに遷移できること' do
      click_on 'Last'
      expect(page).to have_selector('div#test-post', count: 5)
      click_on 'First'
      expect(page).to have_selector('div#test-post', count: 10)
      expect(page).not_to have_content('First')
      expect(page).not_to have_content('Previous')
    end
  end
end
