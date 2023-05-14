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
class Game < ApplicationRecord
  belongs_to :away_team, class_name: 'BaseballTeam'
  belongs_to :home_team, class_name: 'BaseballTeam'
  belongs_to :baseball_park
  belongs_to :user
end
