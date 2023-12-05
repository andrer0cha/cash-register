# frozen_string_literal: true

RSpec.describe CartController, type: :request do
  let!(:current_user) do
    create(:user,
           first_name: 'Current',
           last_name: 'User',
           email: 'current.user@example.com')
  end

  describe 'GET /cart/' do # GET /cart/
    subject(:get_cart) do
      get '/', {}.to_json, { 'Content-Type' => 'application/json' }
    end

    let!(:product_list) do
      create_list(:product, 3)
    end

    context 'when the current_user has products in the cart' do
      before do
        current_user.cart.products << product_list
      end

      it 'returns all the products in the cart' do
        response = get_cart

        expect(JSON.parse(response.body)).to eq(product_list.as_json)
      end
    end

    context 'when the current_user does not have any product in the cart' do
      it 'returns an empty array' do
        response = get_cart

        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when there is no current_user' do
      let(:current_user) do
        nil
      end

      it 'raises ApplicationController::MissingCurrentUser error' do
        aggregate_failures do
          expect { get_cart }.to raise_error(
            ApplicationController::MissingCurrentUser,
            'Current User not found.'
          )
        end
      end
    end
  end

  describe 'PATCH /add_product' do
    subject(:add_to_cart) do
      patch '/add_product', payload, { 'Content-Type' => 'application/json' }
    end

    let(:payload) do
      {
        product_id: existing_product.id
      }.to_json
    end
    let!(:existing_product) do
      create(:product)
    end
    let(:add_to_cart_instance) do
      service = instance_double(AddToCart)

      allow(service).to receive(:call).and_return(true)

      service
    end

    before do
      allow(AddToCart).to receive(:new).and_return(add_to_cart_instance)
    end

    context 'when there is a current_user' do
      it 'calls the AddToCart service' do
        add_to_cart

        aggregate_failures do
          expect(AddToCart).to have_received(:new).with(
            current_user:,
            product_id: JSON.parse(payload)['product_id']
          )
          expect(add_to_cart_instance).to have_received(:call)
        end
      end
    end

    context 'when there is not a current_user' do
      before do
        User.destroy_all
      end

      it 'raises ApplicationController::MissingCurrentUser error' do
        expect { add_to_cart }.to raise_error(
          ApplicationController::MissingCurrentUser,
          'Current User not found.'
        )
      end

      it 'doees not call the AddToCart service' do
        aggregate_failures do
          expect { add_to_cart }.to raise_error(
            ApplicationController::MissingCurrentUser,
            'Current User not found.'
          )
          expect(AddToCart).not_to have_received(:new)
          expect(add_to_cart_instance).not_to have_received(:call)
        end
      end
    end
  end
end
