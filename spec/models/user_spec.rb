require 'spec_helper'

describe User do
	# Factory
	it 'has a valid factory' do
		FactoryGirl.create(:user).should be_valid
	end

	# Validations
	context 'username' do
		it "is invalid when nil or blank" do
			FactoryGirl.build(:user, username: nil).should_not be_valid
		end
		it "is invalid when lt 3 or gt 63 chars" do
			FactoryGirl.build(:user, username: 'Oh').should_not be_valid
			FactoryGirl.build(:user, username: 'too-loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong').should_not be_valid
		end
		it "is invalid when not unique" do
			FactoryGirl.create(:user, username: 'no-doppleganging')
			FactoryGirl.build(:user, username: 'no-doppleganging').should_not be_valid
		end
		it "is invalid when it includes numbers and spaces and symbols" do
			FactoryGirl.build(:user, username: 'space cakes').should_not be_valid
			FactoryGirl.build(:user, username: 'sp@ce').should_not be_valid
			FactoryGirl.build(:user, username: 'one23dohraymee').should_not be_valid
		end
		it "is valid when it is between 3-63 chars" do
			FactoryGirl.build(:user, username: 'jon').should be_valid
			FactoryGirl.build(:user, username: 'Susy-Some-Susy-Some-Susy-Some-Susy-Some-Susy-Some-Susy-Some-S').should be_valid
		end
	end

	# Methods
	it "sets the username to the id when blank" do
		u = FactoryGirl.create(:user, username: '')
		u.username.should == u.id.to_s
	end
end
