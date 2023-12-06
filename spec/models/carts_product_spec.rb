# frozen_string_literal: true

RSpec.describe CartsProduct, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:cart) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:units) }
    it { is_expected.to validate_presence_of(:unit_price) }
  end
end
