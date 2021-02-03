Deface::Override.new virtual_path:  "spree/admin/stock_locations/_form",
                     name:          "add_counties_form",
                     insert_after: '[data-hook="stock_location_state"]',
                     partial:       "spree/admin/stock_locations/county"

Deface::Override.new virtual_path:  "spree/admin/stock_locations/_form",
                     name:          "add_zones_form",
                     insert_after: '[data-hook="stock_location_county"]',
                     partial:       "spree/admin/stock_locations/zones"
