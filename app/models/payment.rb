class Payment < ApplicationRecord
  belongs_to :user

  # バリデーションの記述
  validates :registration_date, presence: true
  with_options presence: true, numericality: { only_integer: true } do
    validates :price, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 999_999 }
    validates :category_id, numericality: { other_than: 1 }
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

  # ユーザーとペアユーザーの投稿情報を取得するメソッド
  def self.find_payments_with_pair(user_id, pair_id, page)
    all_payments = Payment.where(user_id: [user_id, pair_id]).where(registration_date: (30.days.ago)..(Time.now))
    payments = all_payments.page(page).per(10).order('registration_date DESC')
    main_payments = all_payments.where(user_id: user_id)
    pair_payments = all_payments.where(user_id: pair_id)
    [payments, payments, main_payments, pair_payments]
  end
  # // ユーザーとペアユーザーの投稿情報を取得するメソッド

  # ペアが存在しないユーザーの投稿情報を取得するメソッド
  def self.find_payments_with_not_pair(user_id, page)
    Payment.where(user_id: user_id).where(registration_date: (30.days.ago)..(Time.now)).page(page).per(10).order('registration_date DESC')
  end
  # // ペアが存在しないユーザーの投稿情報を取得するメソッド

  def self.result(data)
    result = 0
    data.each do |payment|
      result += payment[:price]
    end
    result
  end
end
