class AddAttachmentAnimGifToImages < ActiveRecord::Migration
  def self.up
    change_table :images do |t|
      t.attachment :anim_gif
    end
  end

  def self.down
    drop_attached_file :images, :anim_gif
  end
end
