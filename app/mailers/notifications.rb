class Notifications < ApplicationMailer
  def welcome_email(user)
    @user = user

    mail to: user.email, subject: "Welcome to Appifly"
  end

  def booking_confirmation(passenger)
    @passenger = passenger

    mail to: passenger.email, subject: "APPIFLY - Flight Booking Update / " \
                                       "Confirmation"
  end
end
