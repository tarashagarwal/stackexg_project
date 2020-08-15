class AddTypeToSpreeProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_products, :type, :string, index: true
  end
end
