require "rails_helper"

RSpec.describe WelcomeHelper, type: :helper do
  # params = {
  #   enquiry: {
  #     origin: "Lagos (LOS)",
  #     destination: "Abuja (ABV)",
  #     departure: Time.now,
  #     view_format: "Grid",
  #     travel_class: "Business",
  #     passenger: "2",
  #     subscription: true,
  #     admin: true,
  #     sql: "Yes",
  #   }
  # }
  # before do
  #   3.times do
  #     create :flight, airline: Faker::Company.name
  #     create :flight, :jfk_flight, airline: Faker::Company.name
  #     create :flight, :cancelled, airline: Faker::Company.name
  #   end
  #   get root_path, enquiry: params[:enquiry]
  # end

  describe "#multiplier" do
    it "assigns a value to a travel class" do
      expect(multiplier["Economy"]).to eq 1
      expect(multiplier["Business"]).to eq 1.5
      expect(multiplier["First"]).to eq 2
    end
  end

  describe "#passenger_class" do
    context "when passenger class is valid" do
      before { @passenger_enquiry = { class_selected: "Business" } }
      it "assigns the value to passenger_class" do
        expect(passenger_class).to eq "Business"
      end
    end

    context "when passenger class is not valid" do
      before { @passenger_enquiry = { class_selected: "Forever" } }
      it "assigns default value to passenger_class" do
        expect(passenger_class).to eq "Economy"
      end
    end
  end
  
  describe "#travel_value" do
    before { @passenger_enquiry = { class_selected: "Business" } }
    it "assigns a numerical value to travel value" do
      expect(travel_value).to eq 1.5
    end
  end

  describe "#search_result_display_format" do
    before do
      2.times { create :flight }
      @passenger_enquiry = { class_selected: "Business", number_travelling: 2 }
      @enquire =  Flight.all
    end
    context "when grid format is selected" do
      before { params[:view_format] = "Grid" }
      it "returns a grid partial view" do
        expect(search_result_display_format).to eq (render "search2")
      end
    end

    context "when list format is selected" do
      before { params[:view_format] = "List" }
      it "returns a list partial view" do
        expect(search_result_display_format).to eq (render "search")
      end
    end
  end
end
