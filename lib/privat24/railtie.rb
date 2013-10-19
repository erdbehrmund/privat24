require 'privat24/privat24_helper'

module Privat24
  class Railtie < Rails::Railtie
    initializer 'privat24.view_helpers' do |app|
      ActionView::Base.send :include, Privat24::Privat24Helper
    end
  end
end
