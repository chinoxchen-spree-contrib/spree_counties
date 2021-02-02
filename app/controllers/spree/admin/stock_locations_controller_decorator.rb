module Spree::Admin::StockLocationsControllerDecorator
  def self.prepended(base)
    base.before_action :set_counties
  end

  private

  def set_counties
    @counties = Spree::County.order(:name)
  end
end

Spree::Admin::StockLocationsController.prepend Spree::Admin::StockLocationsControllerDecorator
