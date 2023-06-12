# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string(255)      not null
#  name            :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_name   (name) UNIQUE
#
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "username#{n}" }
    sequence(:email) { |n| "username#{n}@example.com" }
    password { 'password+1234' }
    password_confirmation { 'password+1234' }
  end
end
