# テーブル設計

## users テーブル

| Column             | Type      | Options                  |
| ------------------ | --------- | ------------------------ |
| nickname           | string    | null: false              |
| email              | string    | null: false, unique :true|
| encrypted_password | string    | null: false              |
| pair_id            | reference | foreign_key :true        |

 - has_many :payments
 - has_one :another
 - belongs_to :pair

## payments テーブル

| Column            | Type      | Options                        |
| ----------------- | --------- | ------------------------------ |
| price             | integer   | null: false                    |
| registration_date | date      | null: false                    |
| category_id       | integer   | null: false                    |
| memo              | text      |                                |
| user              | reference | null: false, foreign_key: true |

 - belongs_to :user