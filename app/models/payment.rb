class Payment < ApplicationRecord

  with_options presence: true do
    validates :registration_date
    validates :user_id
  end

  with_options presence: true, numericality: {only_integer: true} do
    validates :price
    validates :category_id
  end

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  
end