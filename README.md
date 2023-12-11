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
5. Start the server/application by running `bundle exec rackup config.ru`

### Database Diagram
<img width="795" alt="Screenshot 2023-12-11 at 02 36 21" src="https://github.com/andrer0cha/cash-register/assets/87980712/d08f4450-6f3c-4ac4-95ab-f4940ccb868e">


## Possible Next steps
1. Revert the rules when removing product from cart
2. Fix endpoint responses to follow API patterns properly
3. Improve specs
4. Add User Interface / Front-end
5. Improve support for different RuleTypes
