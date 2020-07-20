module SpreeCounties
  module ZoneDecorator
    def self.prepended(base)
      base.has_many :counties, through: :zone_members, source: :zoneable, source_type: 'Spree::County'
    end

    def county?
      kind == 'county'
    end

    def county_ids
      if kind == 'county'
        members.pluck(:zoneable_id)
      else
        []
      end
    end

    def county_ids=(ids)
      set_zone_members(ids, 'Spree::County')
    end

  end
end

::Spree::Zone.prepend SpreeCounties::ZoneDecorator
