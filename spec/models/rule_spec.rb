# frozen_string_literal: true

RSpec.describe Rule, type: :model do
  subject(:create_rule) do
    create(:rule)
  end

  describe 'associations' do
    it { is_expected.to belong_to(:trigger_product).optional(true) }
    it { is_expected.to belong_to(:target_product).optional(true) }
    it { is_expected.to belong_to(:rule_type) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:trigger_amount) }
    it { is_expected.to validate_presence_of(:trigger_amount_type) }
    it { is_expected.to validate_presence_of(:trigger_amount_operator) }
    it { is_expected.to validate_presence_of(:target_amount) }
    it { is_expected.to validate_presence_of(:target_amount_type) }

    it {
      expect(create_rule).to
      validate_inclusion_of(:trigger_amount_type).in_array(described_class::VALID_AMOUNT_TYPES)
    }

    it {
      expect(create_rule).to
      validate_inclusion_of(:target_amount_type).in_array(described_class::VALID_AMOUNT_TYPES)
    }
  end
end
