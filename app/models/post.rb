# == Schema Information
#
# Table name: posts
#
#  id               :bigint           not null, primary key
#  content          :text(65535)      not null
#  title            :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  baseball_park_id :bigint           not null
#  baseball_team_id :bigint           not null
#  category_id      :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_posts_on_baseball_park_id  (baseball_park_id)
#  index_posts_on_baseball_team_id  (baseball_team_id)
#  index_posts_on_category_id       (category_id)
#  index_posts_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (baseball_park_id => baseball_parks.id)
#  fk_rails_...  (baseball_team_id => baseball_teams.id)
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  # rubocop:disable Airbnb/OptArgParameters
  belongs_to :user
  belongs_to :baseball_team
  belongs_to :baseball_park
  belongs_to :category
  has_many :likes
  has_one_attached :photo

  validates :content, presence: true, length: { maximum: 1000 }
  validates :title, presence: true, length: { maximum: 80 }
  validates :baseball_team_id, presence: true
  validates :baseball_park_id, presence: true
  validates :category_id, presence: true
  validates :photo, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["baseball_park_id", "baseball_team_id", "category_id", "title"]
  end
  # rubocop:enable Airbnb/OptArgParameters
end
