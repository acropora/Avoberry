class AddCountToConversations < ActiveRecord::Migration
  def self.up
    add_column :conversations, :count, :integer
  end

  def self.down
    remove_column :conversations, :count
  end
end
