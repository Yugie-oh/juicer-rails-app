# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    @products = Product.juicers.order(:brand, :model)
  end

  def show
    @product = Product.find(params[:id])
  end
end
