require 'spec_helper'
require 'cancan/matchers'

describe Ability do
	context 'as a guest with 0 permissions', slow: true do
		before(:each) do
			@ability = Ability.new(nil, {})
		end

		it "cannot destroy users" do
			@ability.should_not be_able_to(:destroy, :users)
		end
	end
end
