class CreateImagePreviews < ActiveRecord::Migration
  def change
    create_table :image_previews do |t|
      t.string :title
      t.references :user

      t.timestamps
    end
    add_index :image_previews, :user_id
  end
end
