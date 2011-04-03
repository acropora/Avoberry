class ConversationsController < ApplicationController
  
  def index
    received_conversations = Conversation.find(:all, 
    :conditions => ["c_recipient_id = :id or c_recipient2_id = :id", {:id => current_user.id}])
    @found_conversations = Array.new
    received_conversations.each do |c|
      @found_conversations << c if c.search_msgs(params[:search])
      @test = search_conv(c, params[:search].to_s.downcase)
    end
  end
  
  def new
    @title = 'New conversation'
  end

  def show
    @conversation = Conversation.find(params[:id])
    @conversation.all_read(current_user)
  end

  def create
    if !params[:send].nil?
      recipient = User.find_by_name(params[:recipient])
      if recipient.nil?
        flash.now[:error] = 'User not found'
        @title = 'New conversation'
        render 'new'
      else
        @conversation = Conversation.new( :c_sender_id => current_user.id,
                                          :c_recipient_id => recipient.id,
                                          :c_recipient2_id => nil,
                                          :subject => params[:subject],
                                          :c_sender_del => false,
                                          :c_recipient_del => false)
        if @conversation.save and @conversation.create_msg(params[:content], current_user)
          flash[:sucess] = 'Conversation started!'
          redirect_to inbox_conversations_path
        else
          flash.now[:error] = 'Sorry, there was a problem.  Please try again.'
          @title = 'New conversation'
          render 'new'
        end
      end
    end
    if !params[:cancel].nil?
      flash.now[:notice] = 'Message canceled'
      render 'new'
    end
  end
  
  def destroy
    conversation = Conversation.find(params[:id])
    if conversation.c_sender == current_user 
      if conversation.update_attributes(:c_sender_del => true)
        flash.now[:notice] = 'Conversation deleted'
      else
        flash.now[:error] = 'Sorry, there was a problem.  Please try again'
      end
    end
    if conversation.c_recipient == current_user
      if conversation.update_attributes(:c_recipient_del => true)
        flash.now[:notice] = 'Conversation deleted'
      else
        flash.now[:error] = 'Sorry, there was a problem.  Please try again'
      end
    end
    if conversation.c_sender_del and conversation.c_recipient_del
      if conversation.destroy
        flash.now[:notice] = 'Conversation deleted'
      else
        flash.now[:error] = 'Sorry, there was a problem.  Please try again.'
      end
    end
    if params[:folder] == 'sent'
      @conversations = current_user.sent_conversations
      @conv_partial = 'sent_conversations'
    else
      @conversations = get_received
      @conv_partial = 'received_conversations'
    end
    @conversations.each do |c|
      c.update_count(current_user)
    end
    respond_to do |format|
      format.html { render inbox_conversations_path } #need to add extra inbox function calls later
      format.js
    end   
  end
  
  def inbox
    @title = 'Inbox'
    @received_conversations = get_received
    @received_conversations.each do |c|
      c.update_count(current_user)
    end    
  end

  def sent
    @title = 'Sent'
    @sent_conversations = current_user.sent_conversations
  end
  
  def reply
    @conv = Conversation.find(params[:id])
    msg = Msg.new( :conversation_id => params[:id],
                    :content => params[:content],
                    :sender_id => current_user.id,
                    :c_sender_read => false,
                    :c_recip_read => false)
    if msg.save
      if current_user == @conv.c_recipient
        @conv.update_attributes(:c_sender_del => false) if @conv.c_sender_del
        @conv.update_attributes(:c_recipient2_id => @conv.c_sender_id) if @conv.c_recipient2_id.nil?
        msg.update_attributes(:c_recip_read => true)
      end
      if current_user == @conv.c_sender
        @conv.update_attributes(:c_recipient_del => false) if @conv.c_recipient_del
        msg.update_attributes(:c_sender_read => true)
      end
      flash[:success] = 'Reply sent!'
    else
      flash[:error] = 'Sorry, there was a problem.  Please try again'
    end
    @conv.all_read(current_user)
    respond_to do |format|
      format.html { redirect_to @conv }
      format.js
    end
   end
    
  private
  
    def get_received
      Conversation.find(:all, :conditions => 
      ["c_recipient_id = :id or c_recipient2_id = :id", {:id => current_user.id}])
    end
    
    def search_conv(conversation, search)
      if search
        conversation.msgs.each do |msg|
          return true if !msg.content.downcase.match(search).nil?
        end
      end
      return false
    end

end
