class AddCodeToSpreeCounties < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_counties, :code, :string
  end
end
