# lib/tasks/simulate_stock.rake
require "csv"

namespace :stock do
  desc "Generate stock price data"
  task :simulate, [:start_date, :end_date] => :environment do |_t, args|
    drift = 0.0001
    volatility = 0.002

    # Read symbols from CSV file
    stock_symbols = CSV.read("data/symbols_valid_meta.csv", headers: true).map { |row| row["Symbol"] }

    CSV.open("data/stock_prices.csv", "wb") do |csv|
      csv << ["timestamp", "ticker_symbol", "open", "high", "low", "close", "volume"]

      stock_symbols.each do |symbol|
        puts "generating prices for #{symbol}"

        last_price = Random.rand(1.0..400.0)
        current_date = Time.parse(args[:start_date])

        while current_date <= Time.parse(args[:end_date])
          # Update prices only when the exchange is open (9 AM to 4 PM)
          if current_date.hour >= 9 && current_date.hour < 16
            if Random.rand < 0.3 # Random chance to update price
              # Generate a random shock value using Gaussian distribution
              random_shock = Random.rand * Math.sqrt(volatility)
              # Calculate the new price using the Geometric Brownian Motion formula
              price = last_price * Math.exp((drift - (volatility**2) / 2) + volatility * random_shock)
              last_price = price

              # Example: Open, High, Low, Close could be the same for simplicity
              csv << [current_date, symbol, price, price, price, price, Random.rand(100..1000)]
            end
          end
          current_date += 1.minute
        end
      end
    end
  end

  desc "Import stock prices from CSV to PostgreSQL"
  task import_csv: :environment do
    # Note that this path is for postgres running in docker container.
    csv_file_path = "/data/stock_prices.csv"

    sql = <<-SQL
      COPY stock_prices(timestamp, ticker_symbol, open, high, low, close, volume)
      FROM '#{csv_file_path}'
      DELIMITER ','
      CSV HEADER;
    SQL

    ActiveRecord::Base.connection.execute(sql)
  end
end
