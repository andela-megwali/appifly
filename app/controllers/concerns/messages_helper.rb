module Concerns
  module MessagesHelper
    def account_created_message
      "Account created. Sign in to continue."
    end

    def user_update_message
      "User was successfully updated."
    end

    def user_destroyed_message
      "User was successfully destroyed"
    end

    def successful_sign_in_message
      "User successfully signed in."
    end

    def successful_sign_out_message
      "User successfully signed out."
    end

    def invalid_login_message
      "Invalid password or username"
    end

    def flight_created_message
      "Flight was successfully created."
    end

    def flight_updated_message
      "Flight was successfully updated."
    end

    def flight_removed_message
      "Flight #{@flight.code} has been removed."
    end

    def booking_created_message
      "Booking was successfully created."
    end

    def booking_updated_message
      "Booking was successfully updated."
    end

    def booking_cancelled_message
      "Booking was successfully Cancelled"
    end

    def please_sign_in_message
      "There's more but please sign in first :)"
    end

    def not_authorized_message
      "You are not authorized to access the requested page"
    end

    def booking_not_found_message
      "Booking Not Found."
    end

    def booking_found_message
      "Booking Found."
    end

    def select_a_flight_message
      "Select a flight first!"
    end

    def airport_created_message
      "#{@airport.name} Airport has been created."
    end

    def airport_updated_message
      "#{@airport.name} Airport has been updated."
    end

    def airport_removed_message
      "#{@airport.name} has been removed"
    end
  end
end
