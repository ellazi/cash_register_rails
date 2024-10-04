class ProductsController < ApplicationController
  attr_accessor :cart
  def index
    @products = Product.all
  end
end
