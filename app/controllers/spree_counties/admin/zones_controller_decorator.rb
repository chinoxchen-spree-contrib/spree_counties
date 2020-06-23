module SpreeCounties
  module Admin
    module ZonesControllerDecorator
      protected

      def load_data
        @countries = Country.order(:name)
        @states = State.order(:name)
        @counties = County.order(:name)
        @zones = Zone.order(:name)
      end

      Spree::Admin::ZonesController.prepend(self)
    end
  end
end
