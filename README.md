# Cash Register

## Description
This project aims to reproduce a simple cash register that supports business rules like buy-one-get-one-free when adding a product to cart.

## Current suported rules
1. Buy X get Y free - Buy X products and get Y items of same product.
2. Buy X or more items and pays a fixed price per item.
3. Buy X or more items and receives a discount in percentage per item.


## Usage instructions
This app was develop on top of a modular [Sinatra](https://sinatrarb.com/) application and has the following requirements:

`ruby 3.2.2` and 
`bundler 2.4.22`

To run the app, after installing the requirements, one can simply:
1. Clone the repository
2. Navigate to project's folder
3. Run `bundle` to install dependencies
4. Run `bundle exec rake db:create && bundle exec rake db:migrate` to setup databases
5. Run `bundle exec rake db:seed` to populate the database with initial data
6. Start the server/application by running `bundle exec rackup config.ru`

To interact with the app, we should use it as an API, we can use [Postman](https://www.postman.com/) to make requests and check the responses


### Available Routes
- GET `/products` - index of all products in the DB
- GET `/cart` - Current User's cart items
- PATCH `/cart/add_product` - Add product to Current User's cart
  ```
  Request body:
  {
    "product_id": <id_of_product_to_add>,
    "qty_to_add": <units_to_be_added>
  }
  ```
- DELETE `/cart/clean_cart` - Remove all products from current user's cart
- DELETE `/cart/remove_product` - Remove specific product from current user's cart
  ```
  Request body:
  {
    "product_id": <id_of_product_to_delete>,
    "qty_to_delete": <units_to_be_removed_from_cart>
  }
  ```

### How to create a rule
Currently, all the rules are created in the `db/seeds.rb` file, but the architecture is simple and flexible enough to allow it to be created from an endpoint (to be created).
The `rules` database has the following columns:
  - `trigger_product_id`: (Integer that stores the value of the product that will trigger the rule - it allows empty values for rules that check for any product in the cart)
  - `trigger_amount`: (Decimal that stores the value amount that will trigger the rule)
  - `trigger_amount_type`: (String that stores the type of the trigger amount, it can be 'unit', 'cents' or 'percentage')
  - `trigger_amount_operator`: (String that stores the logical operator that the rule will use to compare and see if it should be triggered, it allows:
      - `'GTE' (>=)`
      - `'LTE' (<=)`
      - `'EQ' (==)`
      - `'LT' (<)`
      - `'GT' (>)`
  - `rule_type_id`: (Integer that stores the id of the `RuleType` record that the rule belongs_to
  - `target_product_id`: (Integer that stores the value of the product that will be the target of the rule - will be added to the card or will receive a discount)
  - `target_amount`: (Decimal that stores the value amount for the target item - discount to be given, units to add, price to set, etc.)
  - `target_amount_type`: (String that stores the type of the target amount, it can be 'unit', 'cents' or 'percentage')

### Database Diagram
<img width="795" alt="Screenshot 2023-12-11 at 02 36 21" src="https://github.com/andrer0cha/cash-register/assets/87980712/d08f4450-6f3c-4ac4-95ab-f4940ccb868e">


## Possible Next steps
1. Revert the rules when removing product from cart
2. Fix endpoint responses to follow API patterns properly
3. Improve specs
4. Add User Interface / Front-end
5. Improve support for different RuleTypes
