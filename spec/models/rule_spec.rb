# frozen_string_literal: true

RSpec.describe Rule, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:trigger_product).optional(true) }
    it { is_expected.to belong_to(:target_product).optional(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:trigger_amount) }
    it { is_expected.to validate_presence_of(:trigger_amount_type) }
    it { is_expected.to validate_presence_of(:trigger_amount_operator) }
    it { is_expected.to validate_presence_of(:action) }
    it { is_expected.to validate_presence_of(:target_amount) }
    it { is_expected.to validate_presence_of(:target_amount_type) }
  end
end
