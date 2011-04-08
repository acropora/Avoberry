class Request < ActiveRecord::Base
  
  attr_accessible :recipient_id
  
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
  has_many :friendships
  
  validates :sender_id, :presence => true
  validates :recipient_id, :presence => true
  
end
