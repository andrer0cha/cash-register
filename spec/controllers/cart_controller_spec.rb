# frozen_string_literal: true

RSpec.describe CartController, type: :request do
  describe '/' do # GET /cart/
    subject(:get_cart) do
      get '/', {}.to_json, { 'Content-Type' => 'application/json' }
    end

    let!(:current_user) do
      create(:user,
             first_name: 'Current',
             last_name: 'User',
             email: 'current.user@example.com')
    end

    let!(:product_list) do
      create_list(:product, 3)
    end

    before do
      allow(described_class).to receive(:current_user).and_return(current_user)
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

      it 'returns an empty array' do
        response = get_cart

        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end
end
