class CartsController < ApplicationController
  before_action :set_cart
  # Display the cart
  def show
    # Calculate the basket and total price
    if @cart.empty?
      @basket = "Empty"
      @total_price = 0
    else
      @basket = @cart.map { |product| product["product_code"] }.shuffle.join(', ')
      @total_price = total.round(2)
    end
  end

  # Add a product to the cart
  def add_to_cart
    product = Product.find(params[:id])
    if product
      @cart << product
      redirect_to products_path, notice: 'Product added to cart'
    else
      redirect_to products_path, alert: 'Product not found'
    end
  end

  def clear_cart
    session[:cart] = []
    redirect_to cart_path, notice: 'Cart has been cleared.'
  end

  # Calculate the total price
  def total
    # Group the cart items by product_code
    grouped_cart = @cart.group_by { |product| product["product_code"] }

    sum = 0
    # Iterate over each group of products
    grouped_cart.each do |product_code, products|
      # Extract product details (all products in this group are the same)
      product = products.first
      count = products.size
      price = product["price"]
      discount = product["discount"]

      Rails.logger.debug "Calculating price for product: #{product_code} with discount: #{discount} and count: #{count}"

      # Apply discounts based on the type of discount
      case discount
      when "buy one get one free"
        sum += buy_one_get_one_free(product_code, price, count)
      when "fifty cents off"
        sum += fifty_cents_off(product_code, price, count)
      when "three per two"
        sum += one_third_off(product_code, price, count)
      else
        sum += no_discount(price, count)
      end
    end

    sum.round(2)
  end


  private

  # Calculate discount
  def buy_one_get_one_free(product_code, price, count)
    count >= 2 ? ((count / 2) * price) + ((count % 2) * price) : (count * price)
  end

  def fifty_cents_off(product_code, price, count)
    count >= 3 ? (count * (price - 0.50)) : (count * price)
  end

  def one_third_off(product_code, price, count)
    count >= 3 ? (count * (price * 2/3)) : (count * price)
  end

  def no_discount(price)
    list = @cart.select { |product| product["discount"].nil? || !Product::DISCOUNTS.include?(product["discount"]) }
    list.count * price
  end

  def set_cart
    @cart = session[:cart] ||= []
  end
end
