require 'rails_helper'

RSpec.describe Payment, type: :model do
  before do 
    @payment = FactoryBot.build(:payment)
  end

  describe 'ユーザー新規登録' do
    it 'priceが空では登録できない' do
      @payment.price = ''
      @payment.valid?
      expect(@payment.errors.full_messages).to include "Price can't be blank"
    end
    it ''
  end
end
