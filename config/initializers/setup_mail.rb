ActionMailer::Base.smtp_settings = {
  :address                => "smtp.gmail.com",
  :port                   => 587,
  :domain                 => "www.gmail.com",
  :authentication         => "plain",
  :user_name              => "theavocadooverlord",
  :password               => "avocado1",
  :enable_starttls_auto   => true
}