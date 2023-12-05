# frozen_string_literal: true

RSpec.describe DeleteFromCart do
  subject(:delete_from_cart_call) do
    described_class.new(
      current_user:,
      product_id: product_to_delete.id
    ).call
  end

  let(:products_on_cart) do
    create_list(:product, 5)
  end

  let!(:product_to_delete) do
    products_on_cart.first
  end

  let(:current_user) do
    create(:user)
  end

  before do
    current_user.cart.products = products_on_cart
  end

  it 'deletes the product from cart' do
    delete_from_cart_call

    expect(current_user.cart.products).not_to include(product_to_delete)
  end

  it 'returns the current user cart updated' do
    response = delete_from_cart_call

    expect(response).to eq(
      products_on_cart.excluding(product_to_delete)
    )
  end

  context 'when the product_id given is not valid' do
    before do
      Product.destroy_all
    end

    it 'raises ProductNotFound error' do
      expect { delete_from_cart_call }.to raise_error(
        described_class::ProductNotFound,
        'Product not found for given id.'
      )
    end
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
      current_user.cart.products << product_to_delete
    end

    it 'deletes only one' do
      delete_from_cart_call

      expect(current_user.cart.products).to include(product_to_delete)
    end
  end
end
