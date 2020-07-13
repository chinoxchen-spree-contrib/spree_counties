class AddSpreeCountyReferenceToSpreeAddress < ActiveRecord::Migration[4.2]
  def change
    add_reference :spree_addresses, :county, index: true
  end
end
