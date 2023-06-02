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
  !let(:user) { FactoryBot.create(:user) }
  !let(:baseball_team) { FactoryBot.create(:baseball_team) }
  !let(:baseball_park) { FactoryBot.create(:baseball_park) }

  let(:win_game) { FactoryBot.create(:game, home_team_score: 4, away_team_score: 2) }
  let(:lose_game) { FactoryBot.create(:game, home_team_score: 2, away_team_score: 4) }
  let(:draw_game) { FactoryBot.create(:game, home_team_score: 2, away_team_score: 2) }

  describe 'Gameモデルのアソシエーションが適切に設定されていること' do
    it { should belong_to(:away_team).class_name('BaseballTeam') }
    it { should belong_to(:home_team).class_name('BaseballTeam') }
    it { should belong_to(:baseball_park) }
    it { should belong_to(:user) }
    it { should have_many_attached(:photos) }
  end

  describe 'Gameモデルのバリデーションが適切に設定されていること' do
    it { should validate_presence_of(:date) }
    it { should validate_length_of(:memo).is_at_most(1000) }
  end

  describe 'Gameモデルのメソッドが正しく動作していること' do
    context 'away_resultメソッドが正しい結果を返すこと' do
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
  end
end
