class AddPosterIdToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :poster_id, :integer
    add_index :posts, :poster_id
  end

  def self.down
    remove_column :posts, :poster_id
  end
end
