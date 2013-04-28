class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user
      t.references :image
      t.string :body

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :image_id
  end
end
