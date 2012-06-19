require 'spec_helper'

describe Question do
	# Factory
	it 'has a valid factory' do
		FactoryGirl.create(:question).should be_valid
	end

	# Validations
	context 'question' do
		it "is invalid when nil or blank" do
			FactoryGirl.build(:question, question: nil).should_not be_valid
			FactoryGirl.build(:question, question: '').should_not be_valid
		end
		it "is invalid when it does not end with a question mark" do
			FactoryGirl.build(:question, question: 'Is this a bad question because it has bad punctuation.').should_not be_valid
		end
		it "is invalid when lt 15 or gt 141 chars" do
			FactoryGirl.build(:question, question: 'too short?').should_not be_valid
			FactoryGirl.build(:question, question: 'too loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong?').should_not be_valid
		end
		it "is invalid when not unique in the scope of the questionable_url" do
			FactoryGirl.create(:question, question: 'is this question the same question?', questionable_url: '/popular/url')
			FactoryGirl.build(:question, question: 'is this question the same question?', questionable_url: '/popular/url').should_not be_valid
		end
		it "is valid when it is between 15-141 chars and ends with a question mark" do
			FactoryGirl.build(:question, question: 'is this 15 chr?').should be_valid
			FactoryGirl.build(:question, question: '01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789?').should be_valid
		end
	end
	it "is invalid without a user" do
		FactoryGirl.build(:question, user: nil).should_not be_valid
	end

end
