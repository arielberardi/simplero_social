# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def notify(user, message)
    @message = message
    @user = user

    mail from: Rails.application.credentials.email[:username],
         to: user.email,
         subject: I18n.t('email.notification.subject')
  end
end
