require 'privat24/base_operation'

module Privat24
  class Request < BaseOperation
    # REQUIRED Amount of payment (Float), in :currency
    attr_accessor :amt
    # REQUIRED Currency of payment - one of `Privat24::SUPPORTED_CURRENCIES`
    attr_accessor :order
    # RECOMMENDED Description to be displayed to the user
    attr_accessor :details
    # RECOMMENDED Extended details to be displayed to the user
    attr_accessor :ext_details

    def initialize(options={})
      super(options)

      @merchant_id = options[:merchant_id]
      @merchant_password = options[:merchant_password]
      @return_url = options[:return_url]
      @status_url = options[:status_url]

      @details = options[:details]
      @ext_details = options[:ext_details]

      @order = options[:order]
      @amt = options[:amt]
      @ccy = options[:ccy]

      validate!
    end

  private

    def validate!

      %w(merchant_id merchant_password ccy amt order return_url status_url details ext_details).each do |required_field|
        raise Privat24::Exception.new(required_field + ' is a required field') unless self.send(required_field).to_s != ''
      end

      raise Privat24::Exception.new('currency must be one of '+Privat24::SUPPORTED_CURRENCIES.join(', ')) unless Privat24::SUPPORTED_CURRENCIES.include?(ccy)

      begin
        self.amt = Float(self.amt)
      rescue ArgumentError, TypeError
        raise Privat24::Exception.new('amount must be a number')
      end

      raise Privat24::Exception.new('amount must be more than 0.01') unless amt > 0.01
    end
  end
end
