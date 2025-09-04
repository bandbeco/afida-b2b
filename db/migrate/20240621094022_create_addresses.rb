# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :building_name
      t.string :street_number_and_name, null: false
      t.string :post_town, null: false
      t.string :postcode, null: false
      t.text :additional_notes

      t.timestamps
    end
  end
end
