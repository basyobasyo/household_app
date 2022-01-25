require 'rails_helper'

RSpec.describe Payment, type: :model do
  before do 
    @payment = FactoryBot.build(:payment)
  end

  describe '支払い情報の新規登録ができる場合' do
    it "全ての支払い登録情報が存在する" do
      expect(@payment).to be_valid
    end
    it 'memoは空でも登録ができる' do
      @payment.memo = ""
      expect(@payment).to be_valid
    end
  end
  
  describe '支払い情報の新規登録できない場合' do
    it 'priceが空では登録できない' do
      @payment.price = ''
      @payment.valid?
      expect(@payment.errors.full_messages).to include "Price can't be blank"
    end
    it 'priceが数字以外では登録できない' do
      @payment.price = "abc"
      @payment.valid?
      expect(@payment.errors.full_messages).to include "Price is not a number"
    end
    it 'priceが整数でないと登録できない' do
      @payment.price = 5000.1
      @payment.valid?
      expect(@payment.errors.full_messages).to include('Price must be an integer')
    end
    it '価格に半角数字数字以外が含まれている場合出品できない' do
      @payment.price = '１００'
      @payment.valid?
      expect(@payment.errors.full_messages).to include('Price is not a number')
    end
    it '価格が999,999円以上では登録できない' do
      @payment.price = 1_000_000
      @payment.valid?
      expect(@payment.errors.full_messages).to include('Price must be less than or equal to 999999')
    end
    it 'registration_dateが空では登録できない' do
      @payment.registration_date = ""
      @payment.valid?
      expect(@payment.errors.full_messages).to include "Registration date can't be blank"
    end
    it 'category_idが「1」では登録できない' do
      @payment.category_id = 1
      @payment.valid?
      expect(@payment.errors.full_messages).to include "Category must be other than 1"
    end
    it 'userが紐づいていないと登録ができない' do
      @payment.user = nil
      @payment.valid?
      expect(@payment.errors.full_messages).to include "User must exist"
    end
  end
end
