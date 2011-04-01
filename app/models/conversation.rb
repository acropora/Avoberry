class Conversation < ActiveRecord::Base
  
  attr_accessible :subject, :c_sender_id, :c_recipient_id, :c_recipient2_id, :c_sender_del, 
                  :c_recipient_del, :count
  
  has_many :msgs
  
  belongs_to :c_sender, :class_name => 'User'
  belongs_to :c_recipient, :class_name => 'User'
  
  default_scope :order => 'conversations.created_at DESC'
  
end
