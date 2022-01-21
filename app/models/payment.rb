class Payment < ApplicationRecord
  with_options presence: true do
    validates :registration_date
    validates :user_id
  end

  with_options presence: true, numericality: { only_integer: true } do
    validates :price
    validates :category_id
  end

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category

  def self.calculate(date_from, date_to, id)
    payments = Payment.where(registration_date: date_from..date_to).where(user_id: id)
    result = 0
    payments.each do |payment|
      result += payment[:price]
    end
    result
  end
end
