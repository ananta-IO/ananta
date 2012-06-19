require 'spec_helper'

describe Profile do
	it 'has a valid factory' do
		FactoryGirl.create(:profile).should be_valid
	end
end
