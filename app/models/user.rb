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
    user = User.find(follow_id)
    another_user = User.find(another_id)
    user.update(pair_id: another_id)
    another_user.update(pair_id: follow_id)
  end
    # // フォロー機能のメソッド
end
