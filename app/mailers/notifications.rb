class Notifications < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.signup.subject
  #
  def welcome_email(passenger)
    @passenger = passenger

    mail to: passenger.email, subject: "Welcome"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.forgot_password.subject
  #
  def forgot_password
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.reservation.subject
  #
  def reservation
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.booking_confirmation.subject
  #
  def booking_confirmation(passenger)
    @passenger = passenger

    mail to: passenger.email, subject: "Booking Confirmation"
  end
end
