class AddClassTypeToSpreeProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_products, :class_type, :string, index: true
  end
end
