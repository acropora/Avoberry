class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :photo, :invitaiton_token, :change_password
  
  has_attached_file :photo, :styles => { :small => "150x150>", :thumb => "75x75>", :tiny => "35x35>" } #,
                    #:url => "/:attachment/:id/:style/:basename.:extension",
                    #:path => ":rails_root/public/:attachment/:id/:style:basename.:extension"
  
  #posts
  has_many :received_posts, :class_name => 'Post', :foreign_key => 'user_id'
  has_many :sent_posts, :class_name => 'Post', :foreign_key => 'poster_id'
                    
  #validations
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,      :presence => true, 
                        :length => { :maximum => 50 }
  validates :email,     :presence => true, 
                        :format => { :with => email_regex },
                        :uniqueness => { :case_sensitive => false }
  validates :password,  :presence => true,
                        :confirmation => true,
                        :length => { :within => 6..40 }
                        
  #validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 1.megabyte
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  before_create :encrypt_password
  
  #conversations
  has_many :sent_conversations, :class_name => 'Conversation', :foreign_key => 'c_sender_id'
  #has_many :received_conversations, :class_name => 'Conversation', :foreign_key => 'c_recipient_id'
  #has_many :received_back_conversations, :class_name => 'Conversation', :foreign_key => 'c_recipient2_id'
  
  #friendships
  has_many :friendships, :dependent => :destroy
  has_many :friends, :through => :friendships
  
  #friend requests
  has_many :sent_requests, :class_name => 'Request', :foreign_key => 'sender_id'
  has_many :received_requests, :class_name => 'Request', :foreign_key => 'recipient_id'
  
  def has_password?(submitted_password)
     encrypted_password == encrypt(submitted_password)
   end

   def self.authenticate(email, submitted_password)
     user = find_by_email(email)
     return nil if user.nil?
     return user if user.has_password?(submitted_password)
   end

   def self.authenticate_with_salt(id, cookie_salt)
     user = find_by_id(id)
     return nil if user.nil?
     return user if user.salt == cookie_salt
   end
   
   def self.search(search)
     if search
       find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
      end
    end
   
   def reset_password
     random_pw = put_password(Digest::SHA1.hexdigest([Time.now, rand].join)[0,8])
     (self.change_password = true) if random_pw
     if save
       return random_pw
     else
       return false
     end
   end
   
   def put_password(pw)
     self.password = pw
     self.encrypted_password = encrypt(password)
     if save
       return password 
     else
       return false
     end
   end
   
   #friend feed
   
   def post_feed
     Post.from_users_friends_with(self)
   end
   
   #friendship procedures
   def friend?(friend)
     friendships.find_by_friend_id(friend)
   end

   def friend!(friend, request)
     friendships.create!(:friend_id => friend.id, :request_id => request.id) 
   end

   def unfriend!(friend)
     friendships.find_by_friend_id(friend).destroy
   end

   #request procedures

   def request?(friend)
     Request.find(:all, :conditions => ["sender_id = ? and recipient_id = ?", id, friend.id])
   end

   def self.search(search)
     if search
       find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
     end
   end
   
   private
   
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
   
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
   
    def make_salt 
      secure_hash("#{Time.now.utc}--#{password}")
    end
   
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end 
     
end
