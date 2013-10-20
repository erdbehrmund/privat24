require 'base64'
require 'privat24/base_operation'

module Privat24
  class Response < BaseOperation
    SUCCESS_STATUSES = %w(ok test)

    #attr_reader :encoded_xml, :signature, :xml

    ATTRIBUTES = %w(merchant order amt ccy details state ext_details ref pay_way sender_phone date)

    %w(merchant order details ext_details ref).each do |attr|
      attr_reader attr
    end

    # Amount of payment. MUST match the requested amount
    attr_reader :amt
    # Currency of payment. MUST match the requested currency
    attr_reader :currency
    # Status of payment. One of '
    #   failure 
    #   success
    #   wait_secure - success, but the card wasn't known to the system 
    attr_reader :state

    def initialize(options = {})
      super(options)

      @payment = options[:payment]
      @signature = options[:signature]

      @calculated_signature = ''

      decode!
    end

    # Returns true, if the transaction was successful
    def success?
      (@signature == @calculated_signature) && (SUCCESS_STATUSES.include? self.state)
    end

  private
    def decode!
      @calculated_signature = Digest::SHA1.hexdigest(Digest::MD5.hexdigest("#{@payment}#{@merchant_password}"))

      @decoded_payment = Rack::Utils.parse_nested_query @payment

      ATTRIBUTES.each do |attr|
        self.instance_variable_set('@'+attr, @decoded_payment[attr])
      end
    end
  end
end
