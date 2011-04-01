class CreateConversations < ActiveRecord::Migration
  def self.up
    create_table :conversations do |t|
      t.string  :subject
      t.integer :c_sender_id
      t.integer :c_recipient_id
      t.integer :c_recipient2_id
      t.boolean :c_sender_del, :default => false
      t.boolean :c_recipient_del, :default => false

      t.timestamps
    end
    add_index :conversations, :c_sender_id
    add_index :conversations, :c_recipient_id
    add_index :conversations, :c_recipient2_id
  end

  def self.down
    drop_table :conversations
  end
end
