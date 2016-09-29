class Payment < ActiveRecord::Base
  belongs_to :booking

  # def paypal_url(return_path)
  #   values = {
  #     business: "merchant@gotealeaf.com",
  #     cmd: "_xclick",
  #     upload: 1,
  #     return: "#{Rails.application.secrets.app_host}#{return_path}",
  #     invoice: id,
  #     amount: @booking.total_cost,
  #     item_name: @booking.flight.flight_code,
  #     item_number: @booking.id,
  #     quantity: "1"
  #    }
  # "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  # end
end
