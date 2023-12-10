# frozen_string_literal: true

RSpec.describe DeleteFromCart do
  subject(:delete_from_cart_call) do
    described_class.new(
      current_user:,
      product: product_to_delete,
      qty_to_delete:
    ).call
  end

  let(:products_in_cart) do
    create_list(:product, 5)
  end

  let!(:product_to_delete) do
    products_in_cart.first
  end

  let(:qty_to_delete) do
    1
  end

  let(:current_user) do
    create(:user)
  end

  before do
    products_in_cart.each do |product|
      create(:carts_product, cart: current_user.cart, product:)
    end
  end

  it 'deletes the product from cart' do
    delete_from_cart_call

    expect(current_user.cart.products).not_to include(product_to_delete)
  end

  it 'returns the cart updated' do
    response = delete_from_cart_call

    expect(response).to eq(
      products_in_cart.excluding(product_to_delete)
    )
  end

  context 'when the product is not in cart' do
    let(:product_to_delete) do
      create(:product)
    end

    it 'raises ProductNotInCart error' do
      expect { delete_from_cart_call }.to raise_error(
        described_class::ProductNotInCart,
        'Product not found in cart.'
      )
    end
  end

  context 'when there is more than one item for the given product in cart' do
    before do
      qty_to_delete.times do
        current_user.cart.products << products_in_cart.first
      end
    end

    it 'deletes only the given qty_to_delete' do
      delete_from_cart_call

      expect(current_user.cart.products).to include(product_to_delete).exactly(1)
    end
  end

  context 'when qty_to_delete is greater than the amount of products in cart' do
    let(:qty_to_delete) do
      2
    end

    it 'deletes only the available amount' do
      delete_from_cart_call

      expect(current_user.cart.products).not_to include(product_to_delete)
    end
  end
end
