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
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー登録' do
    context '登録が成功する時' do
      it 'nameが8文字の時、登録できること' do
        @user.name = 'x' * 8
        expect(@user).to be_valid
      end
      it 'nameが20文字の時、登録できること' do
        @user.name = 'x' * 20
        expect(@user).to be_valid
      end
      it 'emailが255文字の時、登録できること' do
        @user.email = 'x' * 241 + '@baseball.test'
        expect(@user).to be_valid
      end
      it 'emailは全て小文字で保存されること' do
        @user.email = 'BASEBALL_MEMORY@BASEBALL.TEST'
        @user.save
        expect(@user.email).to eq 'baseball_memory@baseball.test'
      end
      it 'name、emailが重複していない時、登録できること' do
        @user.name = 'username'
        @user.email = 'username@example.com'
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.name = 'another_user'
        another_user.email = 'another_user@example.com'
        expect(another_user).to be_valid
      end
    end

    context '登録が成功しない時' do
      it 'nameが空の時、登録できないこと' do
        @user.name = ''
        expect(@user).to be_invalid
      end
      it 'nameが7文字以下の時、登録できないこと' do
        @user.name = 'a' * 7
        expect(@user).to be_invalid
      end
      it 'nameが21文字以上の時、登録できないこと' do
        @user.name = 'a' * 21
        expect(@user).to be_invalid
      end
      it 'nameが重複している時、登録できないこと' do
        @user.name = 'username'
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.name = 'username'
        another_user.email = 'another_user@example.com'
        expect(another_user).to be_invalid
      end
      it 'emailが空の時、登録できないこと' do
        @user.email = ''
        expect(@user).to be_invalid
      end
      it 'emailが255文字以上の時、登録できないこと' do
        @user.email = 'x' * 242 + '@baseball.test'
        expect(@user).to be_invalid
      end
      it 'emailのフォーマットが正しくない時、登録できないこと' do
        invalid_addresses = %W(
          baseball@test,com
          baseball@test.
          baseball_test.com
          baseball@test_memory.com
          baseball@test+memory.com
        )
        invalid_addresses.each do |invalid_address|
          @user.email = invalid_address
          expect(@user).to be_invalid
        end
      end
      it 'emailが重複している時、登録できないこと' do
        @user.email = 'username@example.com'
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = 'username@example.com'
        expect(another_user).to be_invalid
      end
      it 'passwordが7文字以下の時、登録できないこと' do
        @user.password = 'abc+123'
        expect(@user).to be_invalid
      end
      it 'passwordに記号がない時、登録できないこと' do
        @user.password = 'abcd1234'
        expect(@user).to be_invalid
      end
      it 'passwordに数字がない時、登録できないこと' do
        @user.password = 'abcd++++'
        expect(@user).to be_invalid
      end
      it 'passwordに仮名文字が含まれる時、登録できないこと' do
        @user.password = 'abc+123あ'
        expect(@user).to be_invalid
      end
      it 'passwordに全角英数字が含まれる時、登録できないこと' do
        @user.password = 'abc+123ｂ'
        expect(@user).to be_invalid
      end
      it 'passwordとpassword_confirmationの値が異なる時、登録できないこと' do
        @user.password = 'abcd+1234'
        @user.password_confirmation = 'abcd+5678'
        expect(@user).to be_invalid
      end
      it 'password_confirmationが空の時、登録できないこと' do
        @user.password_confirmation = ''
        expect(@user).to be_invalid
      end
      it 'passwordとpassword_confirmationの値が異なる時、登録できないこと' do
        @user.password = nil
        expect(@user).to be_invalid
      end
    end
  end
end
