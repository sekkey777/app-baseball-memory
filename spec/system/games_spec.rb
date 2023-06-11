require 'rails_helper'

RSpec.describe "Games", type: :system do
  let(:user) { create(:user) }
  let!(:baseball_team1) { create(:baseball_team, name: 'Team1') }
  let!(:baseball_team2) { create(:baseball_team, name: 'Team2') }
  let!(:baseball_park) { create(:baseball_park, name: 'Park') }

  describe '正常な値で観戦記録を登録する' do
    let(:game) { build(:game, user: user, home_team: baseball_team1, away_team: baseball_team2, baseball_park: baseball_park) }
    before do
      login(user)
      visit new_game_path
    end

    it '観戦記録（予定）を登録できること' do
      select game.home_team.name, from: '応援チーム'
      select game.away_team.name, from: '対戦チーム'
      fill_in '試合日程', with: DateTime.now
      select game.baseball_park.name, from: '球場'
      click_on '記録する'
      expect(page).to have_current_path(games_path)
      expect(page).to have_content('正常に記録しました')
    end

    it '観戦記録（結果）を登録できること' do
      select game.home_team.name, from: '応援チーム'
      fill_in 'game_home_team_score', with: game.home_team_score
      select game.away_team.name, from: '対戦チーム'
      fill_in 'game_away_team_score', with: game.away_team_score
      fill_in '試合日程', with: DateTime.now
      select game.baseball_park.name, from: '球場'
      fill_in '観戦記録', with: game.memo
      click_on '記録する'
      expect(page).to have_current_path(games_path)
      expect(page).to have_content('正常に記録しました')
    end
  end

  describe '異常な値で観戦記録を登録する' do
    before do
      login(user)
      visit new_game_path
    end

    it '空値で観戦記録を登録できないこと' do
      click_on '記録する'
      expect(page).to have_content('記録に失敗しました')
      expect(page).to have_content('応援チーム は必須です')
      expect(page).to have_content('対戦チーム は必須です')
      expect(page).to have_content('球場 は必須です')
      expect(page).to have_content('試合日程 を入力してください')
    end

    it '観戦記録に1000文字以上入力して登録できないこと' do
      fill_in '観戦記録', with: 'x' * 1001
      click_on '記録する'
      expect(page).to have_content('観戦記録 は1000文字以下で入力してください')
    end
  end

  describe '観戦記録詳細、編集' do
    let!(:game) { create(:game, user: user) }
    before do
      login(user)
      visit games_path
      click_on result_for_calendar(game.result)
    end

    it '観戦記録詳細ページに遷移できること' do
      expect(page).to have_current_path(game_path(game))
      expect(page).to have_content('一覧に戻る')
      expect(page).to have_content('変更する')
      expect(page).to have_content('削除する')
    end

    it '観戦記録詳細ページ遷移後、戻るボタンで戻れること' do
      expect(page).to have_current_path(game_path(game))
      click_on '一覧に戻る'
      expect(page).to have_current_path(games_path)
    end

    it '観戦記録を削除できること' do
      click_on '削除する'
      expect(page).to have_current_path(games_path)
      expect(page).to have_content("「#{game.home_team.name}」 vs 「#{game.away_team.name}」の観戦記録を削除しました")
    end

    it '観戦記録を編集できること' do
      # 編集ページに遷移
      click_on '変更する'
      # 観戦記録を編集
      expect(page).to have_current_path(edit_game_path(game))
      select baseball_team1.name, from: '応援チーム'
      fill_in 'game_home_team_score', with: 10
      select baseball_team2.name, from: '対戦チーム'
      fill_in 'game_away_team_score', with: 5
      fill_in '試合日程', with: DateTime.now
      select baseball_park.name, from: '球場'
      click_on '記録する'
      # 観戦記録一覧に遷移する
      expect(page).to have_current_path(games_path)
      expect(page).to have_content('投稿内容を更新しました')
      expect(page).to have_content('◯')
    end
  end

  describe 'カレンダー表示とリスト表示' do
    let!(:game) { create(:game, user: user) }
    before do
      login(user)
      visit games_path
    end

    it '観戦記録一覧ページ遷移時にはカレンダーが表示されていること' do
      expect(page).to have_css('.simple-calendar')
      expect(page).not_to have_css('.table-responsive')
      expect(page).to have_content(result_for_calendar(game.result))
    end
  end
end
