require 'spec_helper'

describe Project do
	it 'has a valid factory' do
		FactoryGirl.create(:project).should be_valid
	end
end
