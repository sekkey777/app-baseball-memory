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
require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Postモデルのアソシエーションが適切に設定されていること' do
    it { should belong_to(:user) }
    it { should belong_to(:baseball_team) }
    it { should belong_to(:baseball_park) }
    it { should belong_to(:category) }
    it { should have_many(:likes) }
  end

  describe 'Postモデルのバリデーションが適切に設定されていること' do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:content).is_at_most(1000) }
    it { should validate_length_of(:title).is_at_most(80) }
    it { should validate_presence_of(:photo) }
  end

  describe 'Postモデルの添付ファイルが適切に設定されていること' do
    it { should have_one_attached(:photo) }
  end

  describe 'Postモデルの検索条件が適切に設定されていること' do
    it {
      expect(described_class.ransackable_attributes(nil)).to eq(['baseball_park_id', 'baseball_team_id', 'category_id', 'title'])
    }
  end
end
