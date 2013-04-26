class AddAttachmentImageToImagePreviews < ActiveRecord::Migration
  def self.up
    change_table :image_previews do |t|
      t.attachment :source
    end
  end

  def self.down
    drop_attached_file :image_previews, :source
  end
end
