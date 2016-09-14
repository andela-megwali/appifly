class WelcomeController < ApplicationController
  def index
  	if params[:enquiry]
      @enquire = Flight.search_flight(params[:enquiry][:origin], 
      	params[:enquiry][:destination], Time.now, params[:enquiry][:departure])

  	  @passenger_enquiry = { "Travel Class" => params[:enquiry][:travel_class],
  	  	"Number Travelling" => params[:enquiry][:passenger].to_i,
  	  }
  	end
  end
end
