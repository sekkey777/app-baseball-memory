# == Schema Information
#
# Table name: baseball_parks
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BaseballPark < ApplicationRecord
end
