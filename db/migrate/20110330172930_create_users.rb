class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :salt
      t.string :encrypted_password
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.integer :invitation_id
      t.integer :invitation_limit
      t.boolean :admin, :default => false

      t.timestamps
    end
    add_index :users, :email, :unique => true
    add_index :users, :invitation_id
  end

  def self.down
    drop_table :users
  end
end
