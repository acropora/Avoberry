class Msg < ActiveRecord::Base
  
  attr_accessible :content, :conversation_id, :sender_id, :c_sender_read, :c_recip_read
  
  belongs_to :conversation
  belongs_to :sender, :class_name => 'User'
  
  default_scope :order => 'msgs.created_at DESC'
  
end
