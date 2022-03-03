class User < ApplicationRecord
  # セルフバリデーションによる記述
  require 'validator/pair_id_check_validator'
  # // セルフバリデーションによる記述

  # deviseによる記述
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # // deviseによる記述

  # アソシエーションの記述
  has_many :payments
  has_one  :main_user, class_name: 'User',
                       foreign_key: 'pair_id'

  belongs_to :pair, class_name: 'User', optional: true
  # // アソシエーションの記述

  # バリデーションの記述
  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{6,}+\z/i }, on: :create # createメソッドのみ適応。followメソッドの際にこのバリデーションがかかってしまうため、updateメソッドを使うことができない
  validates :nickname, presence: true
  validates :email, uniqueness: true
  validates :pair_id, uniqueness: true, pair_id_check: true, on: :update # 新規登録の際にバリデーションが動作しないようにupdateの際にのみ設定
  # // バリデーションの記述

  # フォロー機能のメソッド
  def self.follow(follow_id, another_id)
    User.find(follow_id).update(pair_id: another_id)
    User.find(another_id).update(pair_id: follow_id)
  end
  # // フォロー機能のメソッド

  # フォロー解除メソッド
  def self.pair_unfollow(user_id)
    pair_id = User.find(user_id).pair_id
    User.where(pair_id: [user_id, pair_id]).update_all(pair_id: nil)
  end
  # // フォロー解除メソッド
end
