class AddVoteColumnsToUserAndImages < ActiveRecord::Migration
  add_column :users, :up_votes, :integer, :null => false, :default => 0
  add_column :users, :down_votes, :integer, :null => false, :default => 0
  add_column :images, :up_votes, :integer, :null => false, :default => 0
  add_column :images, :down_votes, :integer, :null => false, :default => 0
end
