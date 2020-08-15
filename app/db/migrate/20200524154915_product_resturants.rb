class ProductResturants < ActiveRecord::Migration[6.0]
  def change
  	create_table :product_resturants do |t|
      t.integer	:resturant_id, null: false
      t.integer :product_id, null: false
      t.timestamps
    end
    add_index :product_resturants, :resturant_id
    add_index :product_resturants, :product_id
  end
end