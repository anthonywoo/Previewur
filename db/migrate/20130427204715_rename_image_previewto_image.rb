class RenameImagePreviewtoImage < ActiveRecord::Migration
  def change
    rename_table :image_previews, :images
  end
end
