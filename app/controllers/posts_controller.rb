class PostsController < ApplicationController
  
  #before_filter :authenticate, :only => [:create, :destroy]
  
  def create
    @user = User.find(params[:post][:user_id])
    @post = current_user.sent_posts.build(params[:post])
    if @post.save
      flash[:success] = 'Post created!'
    else
      flash[:error] = 'Sorry, there was a problem.  Please try again.'
      redirect_to root_path
    end
    @user_posts = @user.received_posts
    respond_to do |format|
      format.html { redirect_to @user }
      format.js  
    end
  end
  
  def destroy
  end
  
end
