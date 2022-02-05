class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.integer     :price, null: false
      t.date        :registration_date, null: false
      t.integer     :category_id, null: false
      t.text        :memo
      t.references  :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
