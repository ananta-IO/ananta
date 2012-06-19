require 'spec_helper'

describe Answer do
	# Factory
	it 'has a valid Factory' do
		FactoryGirl.create(:answer).should be_valid
	end

	# Validations
	context 'state' do
		it "is invalid when nil" do
			FactoryGirl.build(:answer, state: nil).should_not be_valid
		end
		it "is invalid when unanswered" do
			FactoryGirl.build(:answer, state: 'unanswered').should_not be_valid
		end
		it "is invalid when NOT [yes, no, dont_care]" do
			FactoryGirl.build(:answer, state: 'wat').should_not be_valid
		end
		it "is valid when [yes, no, dont_care]" do
			FactoryGirl.build(:answer, state: 'yes').should be_valid
			FactoryGirl.build(:answer, state: 'no').should be_valid
			FactoryGirl.build(:answer, state: 'dont_care').should be_valid
		end
	end
	it "is invalid without a question" do
		FactoryGirl.build(:answer, question: nil).should_not be_valid
	end
	it "is invalid without a user" do
		FactoryGirl.build(:answer, question: nil).should_not be_valid
	end

end
