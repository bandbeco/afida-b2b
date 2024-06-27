class CreatePriceListItems < ActiveRecord::Migration[7.1]
  def change
    create_table :price_list_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
