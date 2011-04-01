class ConversationsController < ApplicationController
  
  def index
    received_conversations = Conversation.find(:all, 
    :conditions => ["c_recipient_id = :id or c_recipient2_id = :id", {:id => current_user.id}])
    @found_conversations = Array.new
    received_conversations.each do |c|
      @found_conversations << c if search_conv(c, params[:search])
      @test = search_conv(c, params[:search].to_s.downcase)
    end
  end
  
  def new
    @title = 'New conversation'
  end

  def show
    @conversation = Conversation.find(params[:id])
    all_read(@conversation)
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
        if @conversation.save && create_msg(@conversation, params[:content])
          flash.now[:sucess] = 'Conversation started!'
          render 'inbox'
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
    @conversation = Conversation.find(params[:id])
    if @conversation.c_sender == current_user 
      if @conversation.update_attributes(:c_sender_del => true)
        flash.now[:notice] = 'Conversation deleted'
      else
        flash.now[:error] = 'Sorry, there was a problem.  Please try again'
      end
    end
    if @conversation.c_recipient == current_user
      if @conversation.update_attributes(:c_recipient_del => true)
        flash.now[:notice] = 'Conversation deleted'
      else
        flash.now[:error] = 'Sorry, there was a problem.  Please try again'
      end
    end
    if @conversation.c_sender_del && @conversation.c_recipient_del
      if @conversation.destroy
        flash.now[:notice] = 'Conversation deleted'
      else
        flash.now[:error] = 'Sorry, there was a problem.  Please try again.'
      end
    end
    @title = 'Inbox'
    render 'inbox'  
  end
  
  def inbox
    @title = 'Inbox'
    @received_conversations = Conversation.find(:all, 
    :conditions => ["c_recipient_id = :id or c_recipient2_id = :id", {:id => current_user.id}])
    @received_conversations.each do |c|
      c.update_attributes(:count => count_unread(c))
    end    
  end

  def sent
    @title = 'Sent'
    @sent_conversations = current_user.sent_conversations
  end
  
  def reply
    conv = Conversation.find(params[:id])
    @msg = Msg.new( :conversation_id => params[:id],
                    :content => params[:content],
                    :sender_id => current_user.id,
                    :c_sender_read => false,
                    :c_recip_read => false)
    if @msg.save
      if current_user == conv.c_recipient
        conv.update_attributes(:c_sender_del => false) if conv.c_sender_del
        conv.update_attributes(:c_recipient2_id => conv.c_sender_id) if conv.c_recipient2_id.nil?
      end
      if current_user == conv.c_sender
        conv.update_attributes(:c_recipient_del => false) if conv.c_recipient_del
      end
      flash[:success] = 'Reply sent!'
    else
      flash[:error] = 'Sorry, there was a problem.  Please try again'
    end
    redirect_to conv
   end
  
  private
   
    def create_msg(conversation, content)
      @msg = Msg.new( :conversation_id => conversation.id,
                      :content => content,
                      :sender_id => current_user.id, 
                      :c_sender_read => false,
                      :c_recip_read => false)
      @msg.save
    end
    
    def all_read(conversation)
      conversation.msgs.each do |msg|
        if (current_user == conversation.c_sender) & !msg.c_sender_read
          msg.update_attributes(:c_sender_read => true)
        end
        if (current_user == conversation.c_recipient) & !msg.c_recip_read
          msg.update_attributes(:c_recip_read => true)
        end
      end
    end
    
    def count_unread(conversation)
      count = 0
      conversation.msgs.each do |msg|
        count += 1 if (current_user == conversation.c_sender) & !msg.c_sender_read
        if (current_user == conversation.c_recipient) & !msg.c_recip_read
          count += 1
          count -= 1 if (current_user == conversation.c_sender) & !msg.c_sender_read    
        end 
      end
      return count
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
