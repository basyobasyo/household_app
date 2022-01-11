# テーブル設計

## users テーブル

| Column             | Type   | Options                  |
| ------------------ | ------ | ------------------------ |
| nickname           | string | null: false              |
| email              | string | null: false, unique :true|
| encrypted_password | string | null: false              |

 - has_many :payments

## payments テーブル

| Column            | Type      | Options                        |
| ----------------- | --------- | ------------------------------ |
| price             | integer   | null: false                    |
| registration_date | date      | null: false                    |
| category_id       | integer   | null: false                    |
| memo              | text      |                                |
| user              | reference | null: false, foreign_key: true |

 - belongs_to :user