require 'rails_helper'

RSpec.describe AirportsController, type: :controller do
  describe '#index' do
    context 'when there are no airports' do
      it 'returns empty array' do
        get :index
        expect(response.body).to eq ""
        expect(assigns(:airports)).to eq []
      end
    end

    context 'when there are airports' do
      before do
        60.times do
          create :airport, name: Faker::Name.name
        end
      end

      it 'returns array of airports' do
        get :index
        expect(assigns(:airports).empty?).to be_falsey
        expect(assigns(:airports)[0]).to be_instance_of Airport
      end

      describe '#pagination' do
        context 'when page is 1' do
          it 'returns airports starting from id 1' do
            get :index
            airports = assigns(:airports)
            expect(airports.size).to eq 30
            expect(airports[0].id).to eq 1
          end
        end

        context 'when page is 2' do
          it 'returns airports starting from id 31 ' do
            get :index, page: 2
            airports = assigns(:airports)
            expect(airports.size).to eq 30
            expect(airports[0].id).to eq 31
          end
        end
      end
    end
  end

  describe "#new" do
    
  end
end
