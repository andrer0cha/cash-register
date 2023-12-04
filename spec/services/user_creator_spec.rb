# frozen_string_literal: true

# frozen_srting_literal: true

RSpec.describe UserCreator do
  subject(:user_creator_call) do
    described_class.new(
      email:,
      first_name:,
      last_name:
    ).call
  end

  let(:email) do
    'current.user@example.com'
  end
  let(:first_name) do
    'Current'
  end
  let(:last_name) do
    'User'
  end

  it 'creates a user with the given arguments' do
    aggregate_failures do
      expect { user_creator_call }.to change(
        User, :count
      ).by(1)

      expect(User.last.attributes.except('id', 'created_at', 'updated_at')).to eq(
        {
          email:,
          first_name:,
          last_name:
        }.as_json
      )
    end
  end

  it 'creates a Cart associated to the created user' do
    aggregate_failures do
      expect { user_creator_call }.to change(
        Cart, :count
      ).by(1)
      expect(Cart.last.user).to eq(User.last)
    end
  end

  context 'when a required argument is missing' do
    let(:email) { nil }

    it 'raises an ActiveRecord error' do
      expect { user_creator_call }.to raise_error(
        ActiveRecord::RecordInvalid,
        "Validation failed: Email can't be blank"
      )
    end

    it 'does not create a User' do
      aggregate_failures do
        expect { user_creator_call }.to raise_error(
          ActiveRecord::RecordInvalid,
          "Validation failed: Email can't be blank"
        )
        expect(User.count).to eq(0)
      end
    end

    it 'does not create a Cart' do
      aggregate_failures do
        expect { user_creator_call }.to raise_error(
          ActiveRecord::RecordInvalid,
          "Validation failed: Email can't be blank"
        )
        expect(Cart.count).to eq(0)
      end
    end
  end
end
