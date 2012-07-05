require 'spec_helper'

describe Profile, slow: true do
	# Factory
	it 'has a valid factory' do
		FactoryGirl.create(:profile).should be_valid
	end

	# Associations
	it { should belong_to(:user) }
	it { should have_many(:images) }
	it { should have_many(:avatars) }
	it { should have_many(:pictures) }

	# Validations
	it "is invalid without a name" do
		FactoryGirl.build(:profile, name: nil).should_not be_valid
	end
end
