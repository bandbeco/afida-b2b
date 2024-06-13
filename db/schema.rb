# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_06_11_213226) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "products", force: :cascade do |t|
    t.citext "sku", null: false
    t.string "name", null: false
    t.text "description"
    t.string "colour"
    t.integer "pac_size"
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "width_in_mm"
    t.integer "depth_in_mm"
    t.integer "height_in_mm"
    t.integer "diameter_in_mm"
    t.integer "volume_in_ml"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sku"], name: "index_products_on_sku"
  end

end
