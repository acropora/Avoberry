class AddChangePasswordToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :change_password, :boolean, :default => false
  end

  def self.down
    remove_column :users, :change_password
  end
end
