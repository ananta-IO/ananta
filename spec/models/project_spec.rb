require 'spec_helper'

describe Project do
	# Factory
	it 'has a valid factory' do
		FactoryGirl.create(:project).should be_valid
	end

	# Validations
	context 'name' do
		it "is invalid when nil or blank" do
			FactoryGirl.build(:project, name: nil).should_not be_valid
			FactoryGirl.build(:project, name: '').should_not be_valid
		end
		it "is invalid when lt 3 or gt 141 chars" do
			FactoryGirl.build(:project, name: 'Oh').should_not be_valid
			FactoryGirl.build(:project, name: 'too loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong').should_not be_valid
		end
		it "is invalid when not unique in the scope of the user_id" do
			FactoryGirl.create(:project, name: 'is this name the same name?', user_id: '1')
			FactoryGirl.build(:project, name: 'is this name the same name?', user_id: '1').should_not be_valid
		end
		it "is valid when it is between 3-141 chars" do
			FactoryGirl.build(:project, name: '123').should be_valid
			FactoryGirl.build(:project, name: '012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890').should be_valid
		end
	end
	it "is invalid without a user" do
		FactoryGirl.build(:project, user: nil).should_not be_valid
	end
end
