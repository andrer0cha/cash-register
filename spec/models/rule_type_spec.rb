# frozen_string_literal: true

RSpec.describe RuleType, type: :model do
  describe 'validations' do
    let(:rule_type) do
      build(:rule_type, internal_reference: 'add_item')
    end

    before do
      create(:rule_type, internal_reference: 'add_item')
    end

    it { is_expected.to validate_presence_of(:description) }

    it 'validates internal_reference uniqueness' do
      expect { rule_type.save! }.to raise_error(
        ActiveRecord::RecordInvalid,
        'Validation failed: Internal reference has already been taken'
      )
    end
  end
end
