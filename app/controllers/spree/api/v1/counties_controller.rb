module Spree
  module Api
    module V1
      class CountiesController < Spree::Api::BaseController
        skip_before_action :authenticate_user

        def index
          @counties = scope.ransack(params[:q]).result.includes(:state).order('name ASC')

          if params[:page] || params[:per_page]
            @counties = @counties.page(params[:page]).per(params[:per_page])
          end

          county = @counties.last
          respond_with(@counties) if stale?(county)
        end

        def show
          @county = scope.find(params[:id])
          respond_with(@county)
        end

        private
        def scope
          if params[:state_id]
            @state = Spree::State.accessible_by(current_ability, :read).find(params[:state_id])
            @state.counties.accessible_by(current_ability, :read)
          else
            Spree::County.accessible_by(current_ability, :read)
          end
        end
      end
    end
  end
end
