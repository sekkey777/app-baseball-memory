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
class User < ApplicationRecord
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)(?=.*?[\W_])[!-~]{8,}+\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { in: 8..20, allow_blank: true }, uniqueness: { case_sensitive: false },
                   unless: :guest?
  validates :email, length: { maximum: 255, allow_blank: true }, format: { with: VALID_EMAIL_REGEX, allow_blank: true },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8, allow_blank: true }, allow_nil: true,
                       format: { with: VALID_PASSWORD_REGEX, message: 'は英数字と記号を含めて下さい' }, unless: :guest?

  has_secure_password

  has_many :posts
  has_many :likes
  has_many :games

  def liked_by?(post_id)
    likes.where(post_id: post_id).exists?
  end

  def guest?
    name == 'guest_user'
  end
end
