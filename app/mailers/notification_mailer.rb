# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.notify.subject
  #
  def notify(user, message)
    @message = message
    @user = user

    mail from: Rails.application.credentials.email[:username],
         to: user.email,
         subject: I18n.t('email.notification.subject')
  end
end
