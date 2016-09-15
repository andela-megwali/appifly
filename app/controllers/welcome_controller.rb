class WelcomeController < ApplicationController
  def index
  	if params[:enquiry]
      @enquire = Flight.sorted.search_flight(params[:enquiry][:origin], 
      	params[:enquiry][:destination], Time.now, params[:enquiry][:departure])
  	  
      session[:passenger_enquiry] = { "Travel Class" => params[:enquiry][:travel_class],
  	  	"Number Travelling" => params[:enquiry][:passenger].to_i,
  	  }
  	  
      @passenger_enquiry = session[:passenger_enquiry]
  	end
  end
end
