class AddCountyNameToSpreeAddress < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_addresses, :county_name, :string
  end
end
