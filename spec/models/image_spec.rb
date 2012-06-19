require 'spec_helper'

describe Image do
	it 'has a valid factory' do
		FactoryGirl.create(:image).should be_valid
	end
end
