class Payment < ApplicationRecord

  # バリデーションの記述
  validates :registration_date, presence: true
  with_options presence: true, numericality: { only_integer: true } do
    validates :price
    validates :category_id
  end
  # //バリデーションの記述

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category

  # ユーザー一人に対する指定された期間の支払い合計を算出するメソッド
  def self.calculate(date_from, date_to, id)
    payments = Payment.where(registration_date: date_from..date_to).where(user_id: id)
    result = 0
    payments.each do |payment|
      result += payment[:price]
    end
    result
  end
  # //ユーザー一人に対する指定された期間の支払い合計を算出するメソッド

end
