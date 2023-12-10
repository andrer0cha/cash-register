# frozen_string_literal: true

RSpec.describe AddToCart do
  subject(:add_to_cart_call) do
    described_class.new(
      current_user:,
      product: existing_product,
      qty_to_add:
    ).call
  end

  let!(:existing_product) do
    create(:product)
  end

  let(:current_user) do
    create(:user)
  end
  let(:qty_to_add) do
    3
  end

  let(:expected_updated_cart) do
    qty_to_add.times.map do
      existing_product
    end
  end

  it 'adds the product to cart' do
    add_to_cart_call

    expect(current_user.cart.products).to include(existing_product)
  end

  it 'returns the current user cart updated' do
    response = add_to_cart_call

    expect(response).to match(expected_updated_cart)
  end

  it 'adds the exact qty_to_add to cart' do
    add_to_cart_call

    expect(current_user.cart.carts_products.pluck(:cart_id, :product_id,
                                                  :unit_price)).to include(
                                                    [current_user.cart.id,
                                                     existing_product.id,
                                                     existing_product.price]
                                                  ).exactly(qty_to_add)
  end

  context 'when the product is already in the cart' do
    before do
      create(:carts_product, cart_id: current_user.cart.id, product_id: existing_product.id,
                             unit_price: existing_product.price, units: 1)
    end

    it 'adds a new CartProduct record' do
      add_to_cart_call

      expect(
        current_user.cart.carts_products.where(
          product_id: existing_product.id
        ).count
      ).to eq(qty_to_add + 1)
    end
  end
end
