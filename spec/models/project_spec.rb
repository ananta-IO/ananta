require 'spec_helper'

describe Project, slow: true do
	# Factory
	it 'has a valid factory' do
		FactoryGirl.create(:project).should be_valid
	end

	# Associations
	it { should belong_to(:user) }
	it { should have_one(:location) }
	it { should have_many(:images) }
	it { should have_many(:avatars) }
	it { should have_many(:pictures) }

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
	it "cannot be deleted if it is the user's last project" do
		u = FactoryGirl.create(:user)
		u.projects.count.should == 1
		u.projects.first.destroy
		u.projects.count.should == 1
	end
	it "can be deleted if the user has multiple projects" do
		u = FactoryGirl.create(:user)
		FactoryGirl.create(:project, user:u)
		u.projects.count.should == 2
		u.projects.first.destroy
		u.projects.count.should == 1
	end
end
