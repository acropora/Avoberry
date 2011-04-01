class CreateMsgs < ActiveRecord::Migration
  def self.up
    create_table :msgs do |t|
      t.string  :content
      t.integer :conversation_id
      t.integer :sender_id
      t.boolean :c_sender_read, :default => false
      t.boolean :c_recip_read, :default => false

      t.timestamps
    end
    add_index :msgs, :conversation_id
    add_index :msgs, :sender_id
  end

  def self.down
    drop_table :msgs
  end
end
