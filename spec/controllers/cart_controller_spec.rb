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
        product_list.each do |product|
          create(:carts_product, cart: current_user.cart, product:)
        end
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
        product_id: existing_product.id,
        qty_to_add: 5
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
            product: Product.find(JSON.parse(payload)['product_id']),
            qty_to_add: JSON.parse(payload)['qty_to_add']
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

      it 'does not call the AddToCart service' do
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

  describe 'DELETE /remove_product' do
    subject(:delete_from_cart) do
      delete '/remove_product', payload, { 'Content-Type' => 'application/json' }
    end

    let(:payload) do
      {
        product_id: existing_product.id,
        qty_to_delete: 2
      }.to_json
    end
    let!(:existing_product) do
      create(:product)
    end
    let(:delete_from_cart_instance) do
      service = instance_double(DeleteFromCart)

      allow(service).to receive(:call).and_return(true)

      service
    end

    before do
      allow(DeleteFromCart).to receive(:new).and_return(delete_from_cart_instance)
    end

    context 'when there is a current_user' do
      it 'calls the DeleteFromCart service' do
        delete_from_cart

        aggregate_failures do
          expect(DeleteFromCart).to have_received(:new).with(
            current_user:,
            product: Product.find(JSON.parse(payload)['product_id']),
            qty_to_delete: 2
          )
          expect(delete_from_cart_instance).to have_received(:call)
        end
      end
    end

    context 'when there is not a current_user' do
      before do
        User.destroy_all
      end

      it 'raises ApplicationController::MissingCurrentUser error' do
        expect { delete_from_cart }.to raise_error(
          ApplicationController::MissingCurrentUser,
          'Current User not found.'
        )
      end

      it 'does not call the DeleteFromCart service' do
        aggregate_failures do
          expect { delete_from_cart }.to raise_error(
            ApplicationController::MissingCurrentUser,
            'Current User not found.'
          )
          expect(DeleteFromCart).not_to have_received(:new)
          expect(delete_from_cart_instance).not_to have_received(:call)
        end
      end
    end
  end

  describe 'DELETE /clean_cart' do
    subject(:clean_cart_call) do
      delete '/clean_cart', {}.to_json, { 'Content-Type' => 'application/json' }
    end

    let!(:products_in_cart) do
      create_list(:product, 3)
    end

    before do
      products_in_cart.each do |product|
        create(:carts_product, cart: current_user.cart, product:)
      end
    end

    it 'removes all products from cart' do
      clean_cart_call

      expect(current_user.cart.products.count).to eq(0)
    end

    it 'returns an empty array' do
      response = clean_cart_call

      expect(JSON.parse(response.body)).to eq([])
    end

    context 'when the cart does not have a product' do
      before do
        current_user.cart.products.destroy_all
      end

      it 'returns an empty array anyways' do
        response = clean_cart_call

        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end
end
