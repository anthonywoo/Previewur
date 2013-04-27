class AddAttachmentPreviewToImagePreviews < ActiveRecord::Migration
  def self.up
    change_table :image_previews do |t|
      t.attachment :preview
    end
  end

  def self.down
    drop_attached_file :image_previews, :preview
  end
end
