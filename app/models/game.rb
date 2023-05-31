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
class Game < ApplicationRecord
  before_save :set_result
  before_update :set_result

  belongs_to :away_team, class_name: 'BaseballTeam'
  belongs_to :home_team, class_name: 'BaseballTeam'
  belongs_to :baseball_park
  belongs_to :user
  has_many_attached :photos

  validates :home_team_id, presence: true
  validates :away_team_id, presence: true
  validates :baseball_park_id, presence: true
  validates :date, presence: true
  validates :memo, length: { maximum: 1000 }
  validates :user_id, presence: true

  def self.win_count
    where(result: 'win').count
  end

  def self.lose_count
    where(result: 'lose').count
  end

  def self.draw_count
    where(result: 'draw').count
  end

  def self.total_count
    count
  end

  def self.win_percentage
    total_games = total_count.to_f
    return 0 if total_games.zero?

    (win_count / total_games * 100).round
  end

  def self.current_sequence
    last_results = pluck(:result).reverse

    sequence_type = nil
    sequence_count = 0

    last_results.each do |result|
      if sequence_type.nil? || sequence_type == result
        sequence_type = result
        sequence_count += 1
      else
        break
      end
    end

    [sequence_type, sequence_count]
  end

  def away_result
    case result
    when "win"
      "lose"
    when "lose"
      "win"
    when "draw"
      "draw"
    else
      "unknown"
    end
  end

  private

  def set_result
    if home_team_score.nil? || away_team_score.nil?
      return self.result = nil
    end

    if home_team_score > away_team_score
      self.result = 'win'
    elsif home_team_score < away_team_score
      self.result = 'lose'
    else
      self.result = 'draw'
    end
  end
end
