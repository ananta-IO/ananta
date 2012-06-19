require 'spec_helper'

describe Answer do
	it 'has a valid factory' do
		FactoryGirl.create(:answer).should be_valid
	end
end
