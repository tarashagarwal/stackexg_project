class RemoveTypeFromSpreeProducts < ActiveRecord::Migration[6.0]
  def change

    remove_column :spree_products, :type, :string
  end
end
