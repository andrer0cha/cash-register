# frozen_string_literal: true

RSpec.describe Cart, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:carts_products) }
    it { is_expected.to have_many(:products).through(:carts_products) }
  end
end
