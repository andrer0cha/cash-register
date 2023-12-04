# frozen_string_literal: true

class CartController < ApplicationController
  get '/' do # GET /cart/
    format_response(
      status: 200,
      body: current_user_cart
    )
  end

  private

  def current_user_cart
    current_user&.cart&.products || []
  end
end
