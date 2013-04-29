class AddSlugToImages < ActiveRecord::Migration
  def change
    add_column :images, :slug, :string
    add_index :images, :slug
  end
end
