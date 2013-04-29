class CreateImageTags < ActiveRecord::Migration
  def change
    create_table :image_tags do |t|
      t.references :user
      t.references :tag

      t.timestamps
    end
    add_index :image_tags, :user_id
    add_index :image_tags, :tag_id
  end
end
