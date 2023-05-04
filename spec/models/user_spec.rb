require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー登録' do
    context '登録が成功する時' do
      it '正常に登録できること' do
        @user = User.new(name: 'username1', email: 'user@email.com', password: 'password+1234')
        expect(@user).to be_valid
      end
    end

    context '登録が成功しない時' do
      it 'nameが空の時、登録できないこと' do
        @user = User.new(email: 'user@email.com', password: 'password+1234')
        expect(@user).to be_invalid
      end
    end
  end
end
