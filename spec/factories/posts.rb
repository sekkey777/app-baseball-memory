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
FactoryBot.define do
  factory :post do
    title { 'test_title' }
    content { 'test_content' }
    photo { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'images', 'test_image.jpg'), 'image/jpeg') }
    association :user
    association :baseball_team
    association :baseball_park
    association :category
  end
end
