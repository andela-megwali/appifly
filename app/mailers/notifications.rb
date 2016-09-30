class Notifications < ApplicationMailer
  def welcome_email(user)
    @user = user

    mail to: user.email, subject: "Welcome to Appifly"
  end

  def booking_confirmation(passenger)
    @passenger = passenger

    mail to: passenger.email, subject: "APPIFLY - Flight Booking Confirmation"
  end

  def booking_update_confirmation(passenger)
    @passenger = passenger

    mail to: passenger.email, subject: "APPIFLY - Your Flight Booking Has Been
                                        Updated"
  end
end
