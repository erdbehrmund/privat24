require 'digest/sha1'

module Privat24
  class BaseOperation
    attr_accessor :merchant_id, :merchant_password, :ccy, :return_url, :status_url, :details, :ext_details

    def initialize(options={})
      options.replace(Privat24.default_options.merge(options))

      @merchant_id = options[:merchant_id]
      @merchant_password = options[:merchant_password]
      @ccy = options[:ccy]
      @return_url = options[:return_url]
      @status_url = options[:status_url]

      @details = options[:details]
      @ext_details = options[:ext_details]
    end

  end
end
