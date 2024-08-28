class OrdersController < ApplicationController
  def checkout
    cart_items = params[:cart_items]
    # Iterate through each selected option in the cart items
    cart_items.each do |cart_item|
      cart_item[:selectedOptions].each do |option_id, option_details|
        stock_level = StockLevel.find_by(option_id: option_details[:id])

        if stock_level.nil? || stock_level.quantity < 1
          # If the stock level is nil or insufficient, respond with an error
          render json: { error: "Insufficient stock for one or more items." }, status: :unprocessable_entity
          return
        else
          # Decrement the stock quantity and update the is_in_stock flag if necessary
          stock_level.quantity -= 1
          stock_level.is_in_stock = false if stock_level.quantity == 0
          stock_level.save!
        end
      end
    end

    # If all items were processed successfully, return a success message
    render json: { message: "Purchase successful!" }, status: :ok
  rescue StandardError => e
    # If an exception occurs, log the error and return an internal server error response
    Rails.logger.error("Error during checkout: #{e.message}")
    render json: { error: "An error occurred during checkout. Please try again." }, status: :internal_server_error
  end
end
