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

ActiveRecord::Schema[7.1].define(version: 2024_01_25_153700) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "stock_prices", force: :cascade do |t|
    t.datetime "timestamp"
    t.string "ticker_symbol"
    t.decimal "open", precision: 10, scale: 4
    t.decimal "high", precision: 10, scale: 4
    t.decimal "low", precision: 10, scale: 4
    t.decimal "close", precision: 10, scale: 4
    t.integer "volume"
    t.index ["ticker_symbol"], name: "index_stock_prices_on_ticker_symbol"
    t.index ["timestamp"], name: "index_stock_prices_on_timestamp"
  end

end
