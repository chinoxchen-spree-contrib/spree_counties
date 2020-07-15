module SpreeCounties
  module Admin
    module ZonesControllerDecorator
      protected

      def load_data
        @countries = Spree::Country.order(:name)
        @states = Spree::State.order(:name)
        @counties = Spree::County.order(:name)
        @zones = Spree::Zone.order(:name)
      end

      Spree::Admin::ZonesController.prepend(self)
    end
  end
end
