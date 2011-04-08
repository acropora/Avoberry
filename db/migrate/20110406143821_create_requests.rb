class CreateRequests < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.integer :sender_id
      t.integer :recipient_id

      t.timestamps
    end
    add_index :requests, :sender_id
    add_index :requests, :recipient_id
  end

  def self.down
    drop_table :requests
  end
end
