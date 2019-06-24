class AdminMailer < ApplicationMailer
  def custom(body, subject = 'Clerk Alert', to = 'invest@forkequity.com')
    @body = body
    mail(to: to, subject: subject)
  end
end
