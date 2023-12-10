# frozen_string_literal: true

RSpec.describe RuleTypes::DiscountProdType do
  subject(:discount_prod_type_call) do
    described_class.new(
      cart:,
      target_product:,
      target_amount:,
      target_amount_type:
    ).call
  end

  let(:cart) do
    create(:cart)
  end

  let(:target_product) do
    create(:product, price: old_price)
  end
  let(:old_price) do
    400
  end
  let(:target_amount) do
    50
  end

  before do
    create(:carts_product, cart:, product: target_product)
  end

  context 'when target_amount_type is cents' do
    let(:target_amount_type) do
      'cents'
    end

    it 'sets the discount correctly' do
      discount_prod_type_call

      expect(cart.carts_products.pluck(:unit_price).uniq).to eq([old_price - target_amount])
    end

    context 'when the discount would set the unit_price to negative' do
      let(:old_price) do
        10
      end

      it 'returns false' do
        response = discount_prod_type_call

        expect(response).to be false
      end

      it 'does not update any record' do
        discount_prod_type_call

        expect(cart.carts_products.pluck(:unit_price).uniq).to eq([old_price])
      end
    end

    context 'when there is more than one target_product in the cart' do
      let(:other_old_price) do
        300
      end

      before do
        create(:carts_product, cart:, product: target_product, unit_price: other_old_price)
      end

      it 'sets the discount correclty to all items' do
        discount_prod_type_call

        expect(
          cart.carts_products.pluck(:unit_price).uniq
        ).to eq(
          [
            (old_price - target_amount),
            (other_old_price - target_amount)
          ]
        )
      end
    end
  end

  context 'when target_amount_type is percentage' do
    let(:target_amount_type) do
      'percentage'
    end

    it 'sets the discount correctly' do
      discount_prod_type_call

      expect(
        cart.carts_products.pluck(:unit_price).uniq
      ).to eq([old_price * ((100.0 - target_amount.to_f) / 100.0)])
    end

    context 'when there is more than one target_product in the cart' do
      let(:other_old_price) do
        300
      end

      before do
        create(:carts_product, cart:, product: target_product, unit_price: other_old_price)
      end

      it 'sets the discount correclty to all items' do
        discount_prod_type_call

        expect(
          cart.carts_products.pluck(:unit_price).uniq
        ).to eq(
          [
            (old_price * ((100.0 - target_amount.to_f) / 100.0)),
            (other_old_price * ((100.0 - target_amount.to_f) / 100.0))
          ]
        )
      end
    end
  end

  context 'when target_amount_type is invalid' do
    let(:target_amount_type) do
      'invalid'
    end

    it 'does nothing' do
      discount_prod_type_call

      expect(cart.carts_products.pluck(:unit_price).uniq).to eq([old_price])
    end

    it 'returns false' do
      response = discount_prod_type_call

      expect(response).to be false
    end
  end
end
