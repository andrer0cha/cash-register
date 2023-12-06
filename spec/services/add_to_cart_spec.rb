# frozen_string_literal: true

RSpec.describe AddToCart do
  subject(:add_to_cart_call) do
    described_class.new(
      current_user:,
      product_id: existing_product.id
    ).call
  end

  let!(:existing_product) do
    create(:product)
  end

  let(:current_user) do
    create(:user)
  end

  it 'adds the product to cart' do
    add_to_cart_call

    expect(current_user.cart.products).to include(existing_product)
  end

  it 'returns the current user cart updated' do
    response = add_to_cart_call

    expect(response).to eq([existing_product])
  end

  context 'when the product_id given is not valid' do
    before do
      Product.destroy_all
    end

    it 'raises ProductNotFound error' do
      expect { add_to_cart_call }.to raise_error(
        described_class::ProductNotFound,
        'Product not found for given id.'
      )
    end
  end

  context 'when the product is already in the cart' do
    before do
      create(:carts_product, cart_id: current_user.cart.id, product_id: existing_product.id,
                             unit_price: existing_product.price, units: 1)
    end

    it 'does not add a new CartProduct record' do
      add_to_cart_call

      expect(
        current_user.cart.carts_products.where(
          product_id: existing_product.id
        ).count
      ).to eq(1)
    end

    it 'updates the units column' do
      add_to_cart_call

      expect(
        current_user.cart.carts_products.where(
          product_id: existing_product.id
        ).first.units
      ).to eq(2)
    end
  end
end
