module Spree::Admin::StockLocationsControllerDecorator
  def self.prepended(base)
    base.before_action :set_counties
    base.before_action :set_zones
  end

  private

  def set_counties
    @counties = Spree::County.order(:name)
  end

  def set_zones
    @zones = Spree::Zone.order(:name)
  end
end

Spree::Admin::StockLocationsController.prepend Spree::Admin::StockLocationsControllerDecorator
