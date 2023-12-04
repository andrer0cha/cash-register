# frozen_string_literal: true

class UserCreator
  extend Dry::Initializer

  option :email
  option :first_name
  option :last_name

  def call
    created_user = User.create!(
      email:,
      first_name:,
      last_name:
    )

    create_user_cart!

    created_user
  end

  private

  def create_user_cart!
    Cart.create!(
      user_id: User.find_by(
        email:,
        first_name:,
        last_name:
      ).id
    )
  end
end
