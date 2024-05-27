class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAILER_SENDER', 'sameenwasee@gmail.com')
  layout 'mailer'
end
