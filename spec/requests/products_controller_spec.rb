# frozen_string_literal: true

RSpec.describe ProductsController, type: :request do
  describe '/products' do
    subject(:get_products_list) do
      get '/products', {}.to_json, { 'Content-Type' => 'application/json' }
    end

    let!(:existing_products) do
      create_list(:product, 10)
    end

    it 'returns all the products in the DB' do
      response = get_products_list

      expect(JSON.parse(response.body)).to eq(existing_products.map(&:attributes).as_json)
    end
  end
end
