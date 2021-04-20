module SpreeCounties
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_counties'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      unless Spree::PermittedAttributes.address_attributes.include?(:county_id)
        Spree::PermittedAttributes.address_attributes << :county_id
      end

      unless Spree::PermittedAttributes.address_attributes.include?(:county_name)
        Spree::PermittedAttributes.address_attributes << :county_name
      end

      unless Spree::PermittedAttributes.address_attributes.include?(:note)
        Spree::PermittedAttributes.address_attributes << :note
      end

      unless Spree::PermittedAttributes.shipment_attributes.include?(:actual_cost)
        Spree::PermittedAttributes.shipment_attributes << :actual_cost
      end

      unless Spree::PermittedAttributes.shipment_attributes.include?(:note)
        Spree::PermittedAttributes.shipment_attributes << :note
      end

      unless Spree::PermittedAttributes.shipment_attributes.include?(:lead_time)
        Spree::PermittedAttributes.shipment_attributes << :lead_time
      end

      unless Spree::PermittedAttributes.stock_location_attributes.include?(:county_id)
        Spree::PermittedAttributes.stock_location_attributes << :county_id
      end

      unless Spree::PermittedAttributes.user_attributes.include?(:county_ids)
        Spree::PermittedAttributes.user_attributes << {county_ids: []}
      end

      Spree::CheckoutController.class_eval do
        helper Spree::AddressesHelper
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
