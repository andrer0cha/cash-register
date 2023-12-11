# frozen_string_literal: true

RSpec.describe RuleTypes::BuyXAndGetY do
  subject(:add_item_call) do
    described_class.new(
      product_to_add:,
      cart:,
      rule_trigger_amount:,
      rule_target_amount:
    ).call
  end

  let(:product_to_add) do
    create(:product)
  end
  let(:cart) do
    create(:cart)
  end
  let(:rule_trigger_amount) do
    1
  end
  let(:rule_target_amount) do
    1
  end
  let(:expected_qty_to_add) do
    1
  end

  before do
    create(:carts_product, cart:, product: product_to_add)
  end

  it 'considers the items in cart to calculate how many free units are missing' do
    add_item_call

    expect(
      CartsProduct.where(product_id: product_to_add.id).count
    ).to eq(expected_qty_to_add + 1)
  end

  it 'returns true' do
    response = add_item_call

    expect(response).to be true
  end

  it 'adds the given product to the cart' do
    add_item_call

    expect(cart.reload.products).to include(product_to_add)
  end

  it 'adds the exact missing_free_items amount' do
    add_item_call

    expect(
      CartsProduct.where(product_id: product_to_add.id).where.not(unit_price: 0.0).count
    ).to eq(expected_qty_to_add)
  end

  it 'adds the product with price set as 0' do
    add_item_call

    expect(CartsProduct.all.pluck(:unit_price).uniq).to eq([product_to_add.price, 0.0])
  end

  context 'when there is no paid items of same type in cart' do
    before do
      CartsProduct.destroy_all
    end

    it 'does not add any items' do
      add_item_call

      expect(CartsProduct.all.pluck(:unit_price).uniq).to eq([])
    end
  end

  context 'when something goes wrong' do
    before do
      allow(CartsProduct).to receive(:insert_all!).and_raise(
        ActiveRecord::RecordNotUnique
      )
    end

    it 'returns false' do
      response = add_item_call

      expect(response).to be false
    end
  end
end
