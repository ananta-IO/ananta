require 'spec_helper'

describe Location, slow: true do
	# Factory
	it 'has a valid factory' do
		FactoryGirl.create(:location).should be_valid
	end

	# Validations
	it "is invalid without a name" do
		FactoryGirl.build(:location, name: nil).should_not be_valid
	end
	it "is invalid without a country" do
		FactoryGirl.build(:location, country: nil).should_not be_valid
	end
	it "is invalid without a city, lat/lon and ip" do
		FactoryGirl.build(:location, city: nil, latitude: nil, ip: nil).should_not be_valid
	end
	it "is invalid without a state, lat/lon and ip" do
		FactoryGirl.build(:location, state: nil, latitude: nil, ip: nil).should_not be_valid
	end
end
