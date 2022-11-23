class ApplicationMailer < ActionMailer::Base
  default from: 'newsletter@newsletter.com'
  layout 'mailer'
end
