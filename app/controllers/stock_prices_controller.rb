class StockPricesController < ApplicationController
  def index
    start_date = stock_price_params[:start_date].to_date
    end_date = stock_price_params[:end_date].to_date if stock_price_params[:end_date].present?
    ticker_symbol = stock_price_params[:ticker_symbol]

    # As default show one day of data
    end_date = start_date + 1.day unless end_date.present?
    # Limit the amount of data to return.
    end_date = [end_date, start_date + 1.month].min if end_date > start_date + 1.month

    stock_prices = StockPrice.all
    stock_prices = stock_prices.where("timestamp >= ?", start_date)
    stock_prices = stock_prices.where("timestamp <= ?", end_date) if end_date.present?
    stock_prices = stock_prices.where(ticker_symbol: ticker_symbol)

    render(json: stock_prices)
  end

  private

  def stock_price_params
    params.require(:start_date)
    params.require(:ticker_symbol)
    params.permit(:start_date, :end_date, :ticker_symbol)
  end
end
