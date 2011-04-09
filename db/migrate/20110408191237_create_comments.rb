class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :poster_id
      t.integer :post_id
      t.string :content

      t.timestamps
    end
    add_index :comments, :poster_id
    add_index :comments, :post_id
  end

  def self.down
    drop_table :comments
  end
end
