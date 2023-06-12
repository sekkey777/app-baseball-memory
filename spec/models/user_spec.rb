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
require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  describe 'Userモデルのアソシエーションが適切に設定されていること' do
    it { should have_many(:posts) }
    it { should have_many(:likes) }
    it { should have_many(:games) }
  end

  describe 'Postモデルのバリデーションが適切に設定されていること' do
    context 'name属性' do
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).is_at_least(8) }
      it { should validate_length_of(:name).is_at_most(20) }
      it { should validate_uniqueness_of(:name).case_insensitive }
    end

    context 'email属性' do
      it { should validate_length_of(:email).is_at_most(255) }
      it { should allow_value('user@example.com').for(:email) }
      it { should_not allow_value('user@example').for(:email) }
      it { should_not allow_value('userexample.com').for(:email) }
      it { should validate_uniqueness_of(:email).case_insensitive }
    end

    context 'password属性' do
      it { should validate_presence_of(:password) }
      it { should validate_length_of(:password).is_at_least(8) }
      it { should allow_value('Abcd123!').for(:password) }
      it { should_not allow_value('password').for(:password) }
      it { should_not allow_value('12345678').for(:password) }
      it { should_not allow_value('abcdEFGH').for(:password) }
      it { should_not allow_value('abcd1234').for(:password) }
      it { should_not allow_value('abcd!@#$').for(:password) }
      it { should_not allow_value('Abcd12345').for(:password) }
      it { should_not allow_value('Abcd+12345あ').for(:password) }
    end

    context 'password_digest属性' do
      it 'passwordとpassword_confirmationの値が異なる時、登録できないこと' do
        user.password = 'abcd+1234'
        user.password_confirmation = 'abcd+5678'
        expect(user).to be_invalid
      end
      it 'password_confirmationが空の時、登録できないこと' do
        user.password_confirmation = ''
        expect(user).to be_invalid
      end
      it 'passwordとpassword_confirmationの値が異なる時、登録できないこと' do
        user.password = nil
        expect(user).to be_invalid
      end
    end
  end
end
