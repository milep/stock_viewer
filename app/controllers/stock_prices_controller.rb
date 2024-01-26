# app/controllers/stock_prices_controller.rb
class StockPricesController < ApplicationController
  def index
    start_date = params[:start_date]
    end_date = params[:end_date]
    ticker_symbol = params[:ticker_symbol]

    # Limit the amount of data to return.
    if start_date.present? && end_date.present?
      start_date = start_date.to_date
      end_date = end_date.to_date
      if end_date > start_date + 1.month
        end_date = start_date + 1.month
      end
    end

    @stock_prices = StockPrice.all
    @stock_prices = @stock_prices.where("timestamp >= ?", start_date) if start_date.present?
    @stock_prices = @stock_prices.where("timestamp <= ?", end_date) if end_date.present?
    @stock_prices = @stock_prices.where(ticker_symbol: ticker_symbol) if ticker_symbol.present?

    render(json: @stock_prices)
  end
end
