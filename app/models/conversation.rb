class Conversation < ActiveRecord::Base
  
  attr_accessible :subject, :c_sender_id, :c_recipient_id, :c_recipient2_id, :c_sender_del, 
                  :c_recipient_del
  
  has_many :msgs
  
  belongs_to :c_sender, :class_name => 'User'
  belongs_to :c_recipient, :class_name => 'User'
  
  default_scope :order => 'conversations.created_at DESC'
  
  def update_count(user)
    num = 0
    msgs.each do |msg|
      num += 1 if (user == c_sender) and !msg.c_sender_read
      if (user == c_recipient) and !msg.c_recip_read
        num += 1
        num -= 1 if (user == c_sender) and !msg.c_sender_read
      end
    end
    self.count = num
    save
  end
  
  def all_read(user)
    msgs.each do |msg|
      if (user == c_sender) and !msg.c_sender_read
        msg.update_attributes(:c_sender_read => true)
      end
      if (user == c_recipient) and !msg.c_recip_read
        msg.update_attributes(:c_recip_read => true)
      end
    end
  end
  
  def create_msg(content, user)
    msg = Msg.new( :conversation_id => id,
                    :content => content,
                    :sender_id => user.id, 
                    :c_sender_read => true,
                    :c_recip_read => false)
    msg.save
  end
  
  def search_msgs(search)
    if search
      msgs.each do |msg|
        return true if !find(:all, :conditions => ['content LIKE ?', "%#{search}"]).empty?
      end
    else
      return false
    end
  end
        
  
end
