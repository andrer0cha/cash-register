# frozen_string_literal: true

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:carts_products) }
    it { is_expected.to have_many(:carts).through(:carts_products) }
  end

  describe 'validations' do
    subject do
      create(:product)
    end

    it { is_expected.to validate_uniqueness_of(:code) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
  end
end
