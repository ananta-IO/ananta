require 'spec_helper'
require 'cancan/matchers'

describe Ability do
	context 'as guest' do
		before(:each) do
			@ability = Ability.new(nil, {})
		end

		it "cannot destroy users" do
			@ability.should_not be_able_to(:destroy, :users)
		end
	end
end
