class Post < ActiveRecord::Base
  
  attr_accessible :content, :user_id
  
  belongs_to :user
  belongs_to :poster, :class_name => 'User'
  
  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  
  default_scope :order => 'posts.created_at DESC'
  
  #Return posts from other users being followed by the given user
  scope :from_users_friends_with, lambda { |user| friends_with(user) }
  
  private
  
  #Return an SQL condition for users followed by the given user
  
  def self.friends_with(user)
    friend_ids = %(SELECT friend_id FROM friendships WHERE user_id = :user_id)  #selecting all friends of user
    where("user_id IN (#{friend_ids}) AND user_id = poster_id",
          { :user_id => user })   #selecting all posts of user where he posts to himself
  end

end
