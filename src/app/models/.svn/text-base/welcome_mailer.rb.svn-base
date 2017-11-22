class WelcomeMailer < ActionMailer::Base
  
  def welcome(user)
    @subject = "Welcome to NETWIRC!"
    @recipients = user.email
    @from = 'admin@netwirc.com'
    @body["user"] = user
  end
  
end