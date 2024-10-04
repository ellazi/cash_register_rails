class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :product_code
      t.string :name
      t.float :price
      t.string :discount

      t.timestamps
    end
  end
end
