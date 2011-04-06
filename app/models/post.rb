class Post < ActiveRecord::Base
  
  attr_accessible :content, :user_id
  
  belongs_to :user
  belongs_to :poster, :class_name => 'User'
  
  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  
  default_scope :order => 'posts.created_at DESC'
  
  #Return posts from other users being followed by the given user
  #scope :from_users_followed_by, lambda { |user| followed_by(user) }
  
  private
  
  #Return an SQL condition for users followed by the given user
  
#  def self.followed_by(user)
#    followed_ids = %(SELECT followed_id FROM relationships WHERE followed_id = ?)
#    where("user_id IN (#{followed_ids})", user)
#  end

end
