class CreateLists < ActiveRecord::Migration[6.1]
  def change
    create_table :lists do |t|

      t.integer :post_id
      t.integer :position
      t.string :content
      t.boolean :checked, default: false 
      t.timestamps
    end
  end
end
