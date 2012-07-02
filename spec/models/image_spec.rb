require 'spec_helper'

describe Image, slow: true do
	it 'has a valid factory' do
		FactoryGirl.create(:image).should be_valid
	end
end
