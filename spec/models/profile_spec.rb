require 'spec_helper'

describe Profile, slow: true do
	# Factory
	it 'has a valid factory' do
		FactoryGirl.create(:profile).should be_valid
	end

	# Validations
	it "is invalid without a name" do
		FactoryGirl.build(:profile, name: nil).should_not be_valid
	end
end
