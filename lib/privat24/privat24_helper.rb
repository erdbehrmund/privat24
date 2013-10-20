module Privat24
  module Privat24Helper
    # Displays a form to send a payment request to LiqPay
    #
    # You can either pass in a block, that SHOULD render a submit button (or not, if you plan to submit the form otherwise), or
    # let the helper create a simple submit button for you.
    #
    # liqpay_request - an instance of Liqpay::Request
    # options - currently accepts two options
    #   id - the ID of the form being created (`liqpay_form` by default)
    #   title - text on the submit button (`Pay with LiqPay` by default); not used if you pass in a block
    def privat24_button(privat24_request, options={}, &block)
      id = options.fetch(:id, 'p24_form')
      title = options.fetch(:title, 'Pay with Privat24')
      content_tag(:form, :id => id, :action => Privat24::ENDPOINT_URL, :method => :post) do
        result = hidden_field_tag(:amt, privat24_request.amount)+
            hidden_field_tag(:ccy, privat24_request.ccy)+
            hidden_field_tag(:merchant, privat24_request.merchant_id)+
            hidden_field_tag(:order, privat24_request.order)+
            hidden_field_tag(:details, privat24_request.details)+
            hidden_field_tag(:ext_details, privat24_request.ext_details)+
            hidden_field_tag(:return_url, privat24_request.return_url)+
            hidden_field_tag(:status_url, privat24_request.status_url)+
            hidden_field_tag(:pay_way, 'privat24');
        if block_given?
          result += capture(&block)
        else
          result += submit_tag(title, :name => nil)
        end
        result
      end
    end
  end
end
