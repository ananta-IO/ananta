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
end
