class AddVoteColumnToImages < ActiveRecord::Migration
  def change
    add_column :images, :up_votes, :integer, :null => false, :default => 0
    add_column :images, :down_votes, :integer, :null => false, :default => 0
  end
end
