# frozen_string_literal: true

RSpec.describe RuleTypes::SetPriceProdType do
  subject(:set_price_prod_type_call) do
    described_class.new(
      cart:,
      target_product:,
      target_price:
    ).call
  end

  let(:target_product) do
    create(:product)
  end
  let(:cart) do
    create(:cart)
  end
  let(:target_price) do
    450
  end
  let(:other_products_price) do
    carts.carts_products.where.not(
      product_id: target_product.id
    ).pluck(:unit_price)
  end
  let(:other_product) do
    create(:product)
  end

  before do
    create(:carts_product, cart:, product: target_product)
    create(:carts_product, cart:, product: other_product)
  end

  it 'returns true' do
    response = set_price_prod_type_call

    expect(response).to be true
  end

  it 'updates all the products in cart of same type' do
    set_price_prod_type_call

    expect(cart.carts_products.reload.where(
      product: target_product
    ).pluck(:unit_price).uniq).to eq([target_price])
  end

  it 'does not update products of different types' do
    set_price_prod_type_call

    expect(
      cart.carts_products.find_by(product: other_product).reload.unit_price
    ).to eq(other_product.price)
  end

  context 'when something goes wrong' do
    before do
      cart.carts_products.where(
        product: target_product
      ).destroy_all
    end

    it 'returns false' do
      response = set_price_prod_type_call

      expect(response).to be false
    end
  end
end
