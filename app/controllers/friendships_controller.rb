class FriendshipsController < ApplicationController
  
  def create
    @friend_request = Request.find(params[:friendship][:request_id])
    @recipient = @friend_request.recipient
    @sender = @friend_request.sender
    if @sender.friend!(@recipient, @friend_request) && @recipient.friend!(@sender, @friend_request)
      @friend_request.update_attributes(:accepted => true)
      flash[:success] = "You are now connected to #{@sender.name}" 
      redirect_to @recipient
    else
      redirect_to root_path
    end
  end
  
  def destroy
  end
  
  def create_request
    @recipient = User.find(params[:request][:recipient_id])
    @friend_request = current_user.sent_requests.build(params[:request])
    if @friend_request.save
      flash.now[:notice] = "Friend request sent!"
    end
    respond_to do |format|
      format.html { redirect_to @recipient }
      format.js
    end
  end

end
