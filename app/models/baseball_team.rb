# == Schema Information
#
# Table name: baseball_teams
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BaseballTeam < ApplicationRecord
  has_one :post
end
