class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :another_user, class_name: "User",
  foreign_key: "pair_id"

  belongs_to :pair, class_name: "User", optional: true
end
