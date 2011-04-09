class Comment < ActiveRecord::Base
  
  belongs_to :post
  belongs_to :poster, :class_name => 'User'
end
