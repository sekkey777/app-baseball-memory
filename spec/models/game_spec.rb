# == Schema Information
#
# Table name: games
#
#  id               :bigint           not null, primary key
#  away_team_score  :integer
#  date             :datetime         not null
#  home_team_score  :integer
#  memo             :text(65535)      not null
#  photo            :string(255)
#  result           :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  away_team_id     :bigint           not null
#  baseball_park_id :bigint           not null
#  home_team_id     :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_games_on_away_team_id      (away_team_id)
#  index_games_on_baseball_park_id  (baseball_park_id)
#  index_games_on_home_team_id      (home_team_id)
#  index_games_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (away_team_id => baseball_teams.id)
#  fk_rails_...  (baseball_park_id => baseball_parks.id)
#  fk_rails_...  (home_team_id => baseball_teams.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Game, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:baseball_team) { FactoryBot.create(:baseball_team) }
  let!(:baseball_park) { FactoryBot.create(:baseball_park) }

  let!(:win_game) { FactoryBot.create(:game, home_team_score: 4, away_team_score: 2, user: user) }
  let!(:win_game2) { FactoryBot.create(:game, home_team_score: 4, away_team_score: 2, user: user) }
  let!(:lose_game) { FactoryBot.create(:game, home_team_score: 2, away_team_score: 4, user: user) }
  let!(:draw_game) { FactoryBot.create(:game, home_team_score: 2, away_team_score: 2, user: user) }
  let!(:scheduled_game) { FactoryBot.create(:game, home_team_score: nil, away_team_score: nil, user: user) }

  describe 'Gameモデルのアソシエーションが適切に設定されていること' do
    it { should belong_to(:away_team).class_name('BaseballTeam') }
    it { should belong_to(:home_team).class_name('BaseballTeam') }
    it { should belong_to(:baseball_park) }
    it { should belong_to(:user) }
  end

  describe 'Gameモデルのバリデーションが適切に設定されていること' do
    it { should validate_presence_of(:date) }
    it { should validate_length_of(:memo).is_at_most(1000) }
  end

  describe 'away_resultメソッドが正しい結果を返すこと' do
    it 'home_teamが勝った時' do
      expect(win_game.away_result).to eq('lose')
    end
    it 'home_teamが負けた時' do
      expect(lose_game.away_result).to eq('win')
    end
    it '引き分けの時' do
      expect(draw_game.away_result).to eq('draw')
    end
  end

  describe 'win_percentageメソッドが正しい結果を返すこと' do
    it '勝率が50%の時' do
      expect(user.games.win_percentage).to eq(50)
    end
  end

  describe 'countメソッドが正しい結果を返すこと' do
    # 2試合に勝利（win_game、win_game2）
    it 'win_countが正しい結果を返すこと' do
      expect(user.games.win_count).to eq(2)
    end
    # 1試合に敗北（lose_game）
    it 'lose_countが正しい結果を返すこと' do
      expect(user.games.lose_count).to eq(1)
    end
    # 1試合に引き分け（draw_game）
    it 'draw_countが正しい結果を返すこと' do
      expect(user.games.draw_count).to eq(1)
    end
    # 4試合の結果（win_game、win_game2、lose_game、draw_game）
    it 'total_result_countが正しい結果を返すこと' do
      expect(user.games.total_result_count).to eq(4)
    end
  end
end
