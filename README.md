# Privat24

## Installation

Include this gem in your app.

## Configuration

The recommended way is setting the `Privat24.default_options` hash somewhere in
your initializers.

You MUST supply next options:
    ccy
    merchant_id
    merchant_password
    return_url
    status_url

Next options are optional:
    details
    ext_details

## Processing payments through Privat24

### General flow

1. User initiates the payment process; you redirect him to Privat24 via POST, providing necessary parameters to set up the payment's amount and description

2. Users completes payment through Privat24

3. Privat24 redirects the user to the URL you specified.

4. You validate the response against your secret signature.

5. If the payment was successful: You process the payment on your side.

6. If the payment was cancelled: You cancel the operation.

### Implementation in Rails 

0. Configure Privat24:

        # config/initializers/privat24.rb
        Privat24.default_options[:merchant_id] = 'MY_MERCHANT_ID'
        Privat24.default_options[:merchant_password] = 'MY_MERCHANT_PASSWORD'
        Privat24.default_options[:ccy] = 'UAH'
        Privat24.default_options[:return_url] = 'http://project.ua/payments/p24r'
        Privat24.default_options[:status_url] = 'http://project.ua/payments/p24s'

1. Create a `Privat24::Request` object

    The required options are: the amount of the payment, and an "order ID".
    "Details" and "Extended details" are optional, if they are specified in initializer.
    
    The "order ID" is just a random string that you will use to
    identify the payment after it has been completed. If you have an `Order`
    model (I suggest that you should), pass its ID. If not, it can be a random
    string stored in the session, or whatever, but *it must be unique*.

        @privat24_request = Privat24::Request.new(
          :amount => '999.99',
          :order_id => '123', 
          :details => 'Some Product',
          :ext_details => 'Very special product'
        )

    **Note that this does not do anything permanent.**
    No saves to the database, no requests to Privat24.
    
2. Put a payment button somewhere

    As you need to make a POST request, there is definitely going to be a form somewhere. 

    To output a form consisting of a single "Pay with LiqPAY" button, do

        <%=privat24_button @privat24_request %>

    Or:

        <%=privat24_button @privat24_request, :title => "Pay now!" %>

    Or:

        <%=privat24_button @privat24_request do %>
          <%=link_to 'Pay now!', '#', :onclick => 'document.forms[0].submit();' %>
        <% end %>

3. Set up a receiving endpoint.
       
        # config/routes.rb
        post '/payments/p24r' => 'payments#return'
        post '/payments/p24s' => 'payments#status'

        # app/controllers/payments_controller.rb
        class PaymentsController < ApplicationController
          # Skipping forgery protection here is important
          protect_from_forgery :except => :return, :status

          def return
            @privat24_response = Privat24::Response.new(params)

            if @privat24_response.success?
              # check that order_id is valid
              # check that amount matches
              # handle success
            else
              # handle error
            end
            rescue Privat24::InvalidResponse
              # handle error
            end
          end

          def status
            @privat24_response = Privat24::Response.new(params)

            if @privat24_response.success?
              # check that order_id is valid
              # check that amount matches
              # handle success
            else
              # handle error
            end
            rescue Privat24::InvalidResponse
              # handle error
            end
          end

### Security considerations

* Check that amount from response matches the expected amount;
* check that the order id is valid;
* check that the order isn't completed yet (to avoid replay attacks); 

- - -

2013 Sergey Sytchewoj

That gem based on gem 'liqpay'