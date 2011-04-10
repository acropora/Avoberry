class UserMailer < ActionMailer::Base
  default :from => "Avocado Overlord"
  
  def registration_confirmation(user)
    mail(:to => user.email, :subject => "Your registration with Project Avocado")
  end
  
  def reset_password(user, password)
    @password = password
    mail(:to => user.email, :subject => "Your temporary Project Avocado password")
  end
  
  def post_notice(user, poster)
    @poster = poster 
    @user = user
    mail(:to => user.email, :subject => "New wall post")
  end
  
  def msg_notice(user)
    @user = user
    mail(:to => user.email, :subject => "New message in your inbox")
  end
  
  def friends_notice(request)
    @sender = request.sender
    @recipient = request.recipient
    mail(:to => @sender.email, :subject => "Your friend request has been accepted")
  end
  
  def request_notice(request)
    @sender = request.sender
    @recipient = request.recipient
    mail(:to => @recipient.email, :subject => "You have a new friend request")
  end
  
end
