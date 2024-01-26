class CreateStockPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :stock_prices do |t|
      t.datetime :timestamp
      t.string :ticker_symbol
      t.decimal :open, precision: 10, scale: 4
      t.decimal :high, precision: 10, scale: 4
      t.decimal :low, precision: 10, scale: 4
      t.decimal :close, precision: 10, scale: 4
      t.integer :volume
    end

    add_index :stock_prices, :timestamp
    add_index :stock_prices, :ticker_symbol
  end
end
