class SessionsController < ApplicationController
  def new
    @title = 'Sign in'
  end
  
  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash[:error] = "The email/password combination does not have an account."
      @title = "Sign in"
      render 'new' 
    else
      sign_in(user, params[:session][:permanent])
      redirect_to inbox_conversations_path
      #redirect_back_or user
    end
  end    
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
