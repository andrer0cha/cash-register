# frozen_string_literal: true

[
  { code: 'GR1', name: 'Green Tea', price: 3.11 },
  { code: 'SR1', name: 'Strawberry', price: 5.00 },
  { code: 'CF1', name: 'Coffee', price: 11.23 }
].each do |product_arguments|
  Product.create!(product_arguments)
end

User.create!(
  first_name: 'Current',
  last_name: 'User',
  email: 'current.user@example.com'
)

Cart.create!(
  user_id: User.find_by(email: 'current.user@example.com')
)
