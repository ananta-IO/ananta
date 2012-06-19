require 'spec_helper'

describe Question do
	it 'has a valid factory' do
		FactoryGirl.create(:question).should be_valid
	end
end
