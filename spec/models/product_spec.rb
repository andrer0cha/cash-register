# frozen_string_literal: true

RSpec.describe Product, type: :model do
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
