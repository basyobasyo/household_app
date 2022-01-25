require 'rails_helper'

RSpec.describe User, type: :model do
  before do 
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録ができる場合' do
    it '全ての情報が正しく存在する' do
      expect(@user).to be_valid
    end
  end

  describe 'ユーザー新規登録ができない場合' do
    it 'nicknameが空では登録できない' do
      @user.nickname = ''
      @user.valid?
      expect(@user.errors.full_messages).to include "Nickname can't be blank"
    end
    it 'emailが空では登録できない' do
      @user.email = ''
      @user.valid?
      expect(@user.errors.full_messages).to include "Email can't be blank"
    end
    it 'emailが他ユーザーのものと同一の際は登録ができない' do
      @user.save
      another_user = FactoryBot.build(:user)
      another_user.email = @user.email
      another_user.valid?
      expect(another_user.errors.full_messages).to include "Email has already been taken"
    end
    it 'emailに「@」が含まれていないと登録できない' do 
      @user.email = "test123gmail.com"
      @user.valid?
      expect(@user.errors.full_messages).to include "Email is invalid"
    end
    it 'passwordが空では登録ができない' do
      @user.password = ''
      @user.valid?
      expect(@user.errors.full_messages).to include "Password can't be blank"
    end
    it 'passwordとpasswordとpassword_confirmationが不一致では登録ができない' do
      other_password_user = FactoryBot.build(:user)
      @user.password = other_password_user.password
      @user.valid?
      expect(@user.errors.full_messages).to include "Password confirmation doesn't match Password"
    end
    it 'passwordが5文字以下では登録できない' do
      @user.password = "aaa11"
      @user.valid?
      expect(@user.errors.full_messages).to include "Password is too short (minimum is 6 characters)"
    end
    it 'passwordが英字のみでは登録できない' do
      @user.password = "aaaaaa"
      @user.valid?
      expect(@user.errors.full_messages).to include "Password is invalid"
    end
    it 'passwordが数字のみでは登録できない' do
      @user.password = "111111"
      @user.valid?
      expect(@user.errors.full_messages).to include "Password is invalid"
    end
    it 'passwordに全角文字文字が含まれる場合登録できない' do
      @user.password = '１２３４５６ｘｙｚ'
      @user.valid?
      expect(@user.errors.full_messages).to include('Password is invalid')
    end
    it 'pair_idはUserテーブル内に該当ユーザーが存在しないと登録できない' do
      @user.save
      pair_user = FactoryBot.create(:user)
      @user.pair_id = pair_user.id
      pair_user.delete
      @user.valid?
      expect(@user.errors.full_messages).to include "Pair is invalid"
    end
    it 'pair_idが他ユーザーと同一のものは登録できない' do
      @user.save
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      user1.update(pair_id: user2.id)
      @user.pair_id = user2.id
      @user.valid?
      expect(@user.errors.full_messages).to include "Pair has already been taken"
    end
  end
  
end
