class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:edit, :update]
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
    #@feed_posts = @user.post_feed  
    #@feed_assignments = @user.assignment_feed
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = 'Welcome to Project Avocado!'
      sign_in @user, '0'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit your profile"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.has_password?(params[:user][:password])
      if @user.update_attributes(params[:user])
        flash[:success] = "Profile updated"
        redirect_to @user
      else
        @title = "Edit your profile"
        render 'edit'
      end
    else 
      flash.now[:error] = "Invalid email/password combination"
      @title = "Edit your profile"
    end
  end  
  
  private 
  
    def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user)
        flash[:error] = 'You do not have permission to access this page'
      end
    end

end
