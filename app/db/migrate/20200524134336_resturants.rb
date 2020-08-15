class Resturants < ActiveRecord::Migration[6.0]
  def change
    create_table :resturants do |t|
      t.boolean    :active, default: false, null: false
      t.string     :address,  null: false
      t.string     :email,  null: false
      t.string     :name,  null: false
      t.string     :code,  null: false
      t.string     :phone,  null: false
      t.timestamps
    end
    add_index :resturants, :active
    add_index :resturants, :code, unique: true
  end
end
