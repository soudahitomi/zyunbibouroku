class CreateLists < ActiveRecord::Migration[6.1]
  def change
    create_table :lists do |t|

      t.integer :posts_id
      t.integer :position
      t.string :content
      t.timestamps
    end
  end
end
