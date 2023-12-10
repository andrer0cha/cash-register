# frozen_string_literal: true

RSpec.describe RuleTypes::AddItem do
  subject(:add_item_call) do
    described_class.new(
      product_to_add:,
      cart:,
      qty_to_add:
    ).call
  end

  let(:product_to_add) do
    create(:product)
  end
  let(:cart) do
    create(:cart)
  end
  let(:qty_to_add) do
    2
  end

  it 'returns true' do
    response = add_item_call

    expect(response).to be true
  end

  it 'adds the given product to the cart' do
    add_item_call

    expect(cart.reload.products).to include(product_to_add)
  end

  it 'adds the exact qty_to_add amount' do
    add_item_call

    expect(CartsProduct.where(product_id: product_to_add.id).count).to eq(qty_to_add)
  end

  it 'adds the product with price set as 0' do
    add_item_call

    expect(CartsProduct.all.pluck(:unit_price).uniq).to eq([0.0])
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
