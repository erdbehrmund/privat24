require 'privat24/version'
require 'privat24/request'
require 'privat24/response'

require 'privat24/railtie' if defined?(Rails)

module Privat24
  ENDPOINT_URL = 'https://api.privatbank.ua/p24api/ishop'
  SUPPORTED_CURRENCIES = %w(UAH USD EUR RUR)

  @default_options = {}
  class << self; attr_accessor :default_options; end

  class Exception < ::Exception; end
  class InvalidResponse < Exception; end
end
