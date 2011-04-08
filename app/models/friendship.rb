class Friendship < ActiveRecord::Base
  
  attr_accessible :friend_id, :request_id
  
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  belongs_to :request
  
  validates :user_id, :presence => true
  validates :friend_id, :presence => true
  validates :request_id, :presence => true
  
end
