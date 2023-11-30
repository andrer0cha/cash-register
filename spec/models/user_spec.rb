# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'validations' do
    subject do
      create(:user)
    end

    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
  end

  describe 'associations' do
    it { is_expected.to have_one(:cart) }
  end
end
