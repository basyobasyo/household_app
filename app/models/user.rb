class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :another_user, class_name: "User",
  foreign_key: "pair_id"

  belongs_to :pair, class_name: "User", optional: true

  def self.follow(follow_id,another_id)
    user = User.find(follow_id)
    user.pair_id = another_id
    another_user = User.find(another_id)
    another_user.pair_id = follow_id

    user.save
    another_user.save
  end

end
