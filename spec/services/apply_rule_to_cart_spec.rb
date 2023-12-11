# frozen_string_literal: true

RSpec.describe ApplyRuleToCart do
  subject(:apply_rule_to_cart_call) do
    described_class.new(
      rule:,
      cart:
    ).call
  end

  let(:cart) do
    create(:cart)
  end

  let(:rule) do
    create(:rule, rule_type:, trigger_amount_operator:, trigger_product:, trigger_amount:,
                  trigger_amount_type:)
  end

  let(:carts_trigger_product) do
    create(:product)
  end

  let(:bxgy_instance) do
    instance = instance_double(RuleTypes::BuyXAndGetY)

    allow(instance).to receive(:call)

    instance
  end
  let(:set_price_prod_type_instance) do
    instance = instance_double(RuleTypes::SetPriceProdType)

    allow(instance).to receive(:call)

    instance
  end
  let(:discount_prod_type_instance) do
    instance = instance_double(RuleTypes::DiscountProdType)

    allow(instance).to receive(:call)

    instance
  end
  let(:different_product) do
    create(:product)
  end

  before do
    allow(RuleTypes::BuyXAndGetY).to receive(:new).and_return(bxgy_instance)
    allow(RuleTypes::SetPriceProdType).to receive(:new).and_return(set_price_prod_type_instance)
    allow(RuleTypes::DiscountProdType).to receive(:new).and_return(discount_prod_type_instance)

    create_list(:carts_product, 2, cart:, product: different_product)
    create_list(:carts_product, 2, cart:, product: carts_trigger_product)
  end

  context 'when the rule is of type bxgy' do
    let(:rule_type) do
      create(:rule_type, internal_reference: 'bxgy')
    end

    # Skipping the specs for the other operators and rule types for simplicity since it is just a challange
    context 'when the operator is GTE' do
      let(:trigger_amount_operator) do
        'gte'
      end

      context 'when trigger_amount_type is unit' do
        let(:trigger_amount_type) do
          'unit'
        end

        context 'when the rule has a trigger_product' do
          let(:trigger_product) do
            carts_trigger_product
          end

          context 'when the rule trigger_amount is lower than qty of trigger_product itens in cart' do
            let(:trigger_amount) do
              CartsProduct.where(cart:, product: trigger_product).count - 1
            end

            it 'calls ::RuleTypes::BuyXAndGetY' do
              apply_rule_to_cart_call

              expect(RuleTypes::BuyXAndGetY).to have_received(:new)
              expect(bxgy_instance).to have_received(:call)
            end
          end

          context 'when the rule trigger_amount is GTE than qty of trigger_product itens in cart' do
            let(:trigger_amount) do
              CartsProduct.where(cart:, product: trigger_product).count + 1
            end

            it 'does not call ::RuleTypes::BuyXAndGetY' do
              apply_rule_to_cart_call

              expect(RuleTypes::BuyXAndGetY).not_to have_received(:new)
            end
          end
        end

        context 'when the rule does not have a trigger_product' do
          let(:trigger_product) do
            nil
          end

          context 'when the rule trigger_amount is lower than qty of any products itens in cart' do
            let(:trigger_amount) do
              CartsProduct.where(cart:).count - 1
            end

            it 'calls ::RuleTypes::BuyXAndGetY' do
              apply_rule_to_cart_call

              expect(RuleTypes::BuyXAndGetY).to have_received(:new)
              expect(bxgy_instance).to have_received(:call)
            end
          end

          context 'when the rule trigger_amount is GTE than qty of any products itens in cart' do
            let(:trigger_amount) do
              CartsProduct.where(cart:).count + 1
            end

            it 'does not call ::RuleTypes::BuyXAndGetY' do
              apply_rule_to_cart_call

              expect(RuleTypes::BuyXAndGetY).not_to have_received(:new)
            end
          end
        end
      end

      context 'when trigger_amount_type is cents' do
        let(:trigger_amount_type) do
          'cents'
        end

        context 'when the rule has a trigger_product' do
          let(:trigger_product) do
            carts_trigger_product
          end

          context 'when the rule trigger_amount is lower than qty of trigger_product itens in cart' do
            let(:trigger_amount) do
              (CartsProduct.where(cart:,
                                  product: trigger_product).sum(:unit_price).to_f / 100.0) - 1
            end

            it 'calls ::RuleTypes::BuyXAndGetY' do
              apply_rule_to_cart_call

              expect(RuleTypes::BuyXAndGetY).to have_received(:new)
              expect(bxgy_instance).to have_received(:call)
            end
          end

          context 'when the rule trigger_amount is GTE than qty of trigger_product itens in cart' do
            let(:trigger_amount) do
              (CartsProduct.where(cart:,
                                  product: trigger_product).sum(:unit_price).to_f / 100.0) + 1
            end

            it 'does not call ::RuleTypes::BuyXAndGetY' do
              apply_rule_to_cart_call

              expect(RuleTypes::BuyXAndGetY).not_to have_received(:new)
            end
          end
        end

        context 'when the rule does not have a trigger_product' do
          let(:trigger_product) do
            nil
          end

          context 'when the rule trigger_amount is lower than qty of any products itens in cart' do
            let(:trigger_amount) do
              (CartsProduct.where(cart:).sum(:unit_price).to_f / 100.0) - 1
            end

            it 'calls ::RuleTypes::BuyXAndGetY' do
              apply_rule_to_cart_call

              expect(RuleTypes::BuyXAndGetY).to have_received(:new)
              expect(bxgy_instance).to have_received(:call)
            end
          end

          context 'when the rule trigger_amount is GTE than qty of any products itens in cart' do
            let(:trigger_amount) do
              (CartsProduct.where(cart:).sum(:unit_price).to_f / 100.0) + 1
            end

            it 'does not call ::RuleTypes::BuyXAndGetY' do
              apply_rule_to_cart_call

              expect(RuleTypes::BuyXAndGetY).not_to have_received(:new)
            end
          end
        end
      end
    end
  end
end
