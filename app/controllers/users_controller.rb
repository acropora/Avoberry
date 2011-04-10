class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:edit, :update, :index]
  before_filter :correct_user, :only => [:edit, :update]
  
  def index
    @users = User.search(params[:search])
  end

  def new
    @title = 'Sign up'
    @user = User.new
    #@user = User.new(:invitation_token => params[:invitation_token])
  end

  def show
    @user = User.find_by_id(params[:id])
    @title = @user.name
    @post = current_user.sent_posts.build
    @user_posts = @user.received_posts
    @friends_feed = @user.post_feed  
    #@feed_assignments = @user.assignment_feed
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.registration_confirmation(@user).deliver
      flash[:success] = 'Welcome to Project Avocado!'
      sign_in @user, '0'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @title = "Edit your profile"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.has_password?(params[:old_password])
      if @user.update_attributes( :name => params[:name], 
                                  :email => params[:email],
                                  :password => params[:password],
                                  :password_confirmation => params[:password_confirmation])
        if @user.put_password(params[:password])
          if @user.change_password
            @user.update_attributes(:change_password => false)
          end
        end
        flash[:success] = "Profile updated"
        redirect_to @user
      else
        @title = "Edit your profile"
        render 'edit'
      end
    else 
      flash.now[:error] = "Invalid email/password combination"
      @title = "Edit your profile"
      render 'edit'
    end
  end  
  
  def reset
    @user = User.find_by_email(params[:email])
    if @user and User.find_by_name(params[:name])
      if password = @user.reset_password        
        UserMailer.reset_password(@user, password).deliver
        flash[:notice] = 'A temporary password has been sent to your email address' 
        redirect_to signin_path
      else
        flash[:error] = "Sorry, there was a problem.  Please try again"
        redirect_to recover_path
      end
    else
      flash[:error] = "Invalid email/name combination"
      redirect_to recover_path
    end
  end
  
  def new_post
    @user = User.find(params[:post][:user_id])
    new_post = current_user.sent_posts.build(params[:post])
    if new_post.save
      if !current_user?(@user)
        UserMailer.post_notice(@user, current_user).deliver
      end
      flash[:success] = 'Post created!'
    else
      flash[:error] = 'Sorry, there was a problem.  Please try again.'
      redirect_to root_path
    end
    @user_posts = @user.received_posts
    @post = Post.new
    respond_to do |format|
      format.html { redirect_to @user }
      format.js  
    end
  end
  
  def show_form
    @post_id = params[:post_id].to_s
    respond_to do |format|
      format.html { redirect_to current_user }  #need to take care of html request
      format.js
    end
   end
  
  def comment_reply
    if params[:real_commit] == 'comment' #handle reply request
      @post = Post.find(params[:post_id])
      @comment = @post.comments.build(:content => params[:content], :poster_id => current_user.id)
      if @comment.save
        flash.now[:success] = 'Comment saved!'
      else
        flash.now[:error] = 'There was a problem.  Please try again'
        redirect_to user_path(params[:id])
      end
    end
    @user_posts = User.find(params[:id]).received_posts
    respond_to do |format|
      format.html { redirect_to current_user } #need to take care of html request
      format.js
    end
  end
  
  private 
  
    def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user)
        flash[:error] = 'You do not have permission to access this page'
        redirect_to root_path
      end
    end

end
