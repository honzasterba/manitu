class Notifier < ActionMailer::Base
  
# subject - The subject of your email. Sets the Subject: header.
# from - Who the email you are sending is from. Sets the From: header.
# cc - Takes one or more email addresses. These addresses will receive a carbon copy of your email. Sets the Cc: header.
# bcc - Takes one or more email address. These addresses will receive a blind carbon copy of your email. Sets the Bcc header.
# sent_on - The date on which the message was sent. If not set, the header wil be set by the delivery agent.
# content_type - Specify the content type of the message. Defaults to text/plain.
# headers - Specify additional headers to be set for the message, e.g. headers ‘X-Mail-Count’ => 107370.   
  
  def forgot_password(recipient, new_pass)
    subject    = 'Manitu.cz: Zapomenuté heslo'
    recipients recipient.email
    from       'no-reply@boomy.cz'
    body       :user => recipient, 
               :new_pass => new_pass
  end
  
  def welcome_mail(user, url)
    subject     "Vítej na Manitú.cz #{user.nick}"
    from        "noreply@manitu.cz"
    recipients  user.email
    body        :user => user, 
                :link => url
  end

  def error_notify(report)
    subject     "Manitú.cz: Nastal problém na #{report.site.adress}"
    from        "notifications@manitu.cz"
    recipients  report.recipients
    body        :report => report
  end
  
  def fixed_notify(report)
    subject     "Manitú.cz: Problém vyřešen na #{report.site.adress}"
    from        "notifications@manitu.cz"
    recipients  report.recipients
    body        :report => report
  end
end
