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

	# Scopes
	context 'Scopes' do
		after :each do
			@query.class.should be ActiveRecord::Relation
			@query.count.should be 1
			@query.first.question.should == 'the question we are testing for?'
		end

		it "published - returns a collection of published questions" do
			FactoryGirl.create(:question, state: 'unpublished')
			FactoryGirl.create(:question, state: 'published', question: 'the question we are testing for?')
			@query = Question.published
		end

		it "answered - returns a collection of answered questions" do
			FactoryGirl.create(:question, answer_count: 0)
			FactoryGirl.create(:question, answer_count: 1, question: 'the question we are testing for?')
			@query = Question.answered
		end

		it "answered_by - returns a collection of questions answered_by a specific user" do
			FactoryGirl.create(:question)
			q = FactoryGirl.create(:question, question: 'the question we are testing for?')
			a = FactoryGirl.create(:answer, question: q)
			@query = Question.answered_by a.user.id
		end

		it "unanswered - returns a collection of unanswered questions" do
			FactoryGirl.create(:question, answer_count: 0, question: 'the question we are testing for?')
			FactoryGirl.create(:question, answer_count: 1)
			@query = Question.unanswered
		end

		it "unanswered_by - returns a collection of unanswered questions" do
			FactoryGirl.create(:question, answer_count: 0, question: 'the question we are testing for?')
			FactoryGirl.create(:question, answer_count: 1)
			@query = Question.unanswered
		end

		it "(alt) unanswered_by - ALSO returns a collection of questions unanswered_by a specific user" do
			q = FactoryGirl.create(:question, answer_count: 1, question: 'the question we are testing for?')
			FactoryGirl.create(:answer, question: q)
			q = FactoryGirl.create(:question, answer_count: 1)
			a = FactoryGirl.create(:answer, question: q)
			@query = Question.unanswered_by a.user.id
		end

		it "q_url - returns a collection of questions filtered by similar questionable_urls" do
			FactoryGirl.create(:question, questionable_url: 'http://www.ananta.io/')
			FactoryGirl.create(:question, questionable_url: 'http://www.ananta.io/blah/blah', question: 'the question we are testing for?')
			@query = Question.q_url 'http://www.ananta.io/blah'
		end

		it "q_sid - returns a collection of questions matching a questionable_sid" do
			FactoryGirl.create(:question, questionable_sid: 'apple')
			FactoryGirl.create(:question, questionable_sid: 'juice', question: 'the question we are testing for?')
			@query = Question.q_sid 'juice'
		end

		it "q_controller - returns a collection of questions matching a questionable_controller" do
			FactoryGirl.create(:question, questionable_controller: 'users')
			FactoryGirl.create(:question, questionable_controller: 'projects', question: 'the question we are testing for?')
			@query = Question.q_controller 'projects'
		end

		it "q_action - returns a collection of questions matching a questionable_action" do
			FactoryGirl.create(:question, questionable_action: 'show')
			FactoryGirl.create(:question, questionable_action: 'index', question: 'the question we are testing for?')
			@query = Question.q_action 'index'
		end
	end

	# Methods
	context 'answer' do
		before :all do
			@question = FactoryGirl.create(:question)
			@user = FactoryGirl.create(:user)
			@params = { state_event: 'ans_yes', comment: 'blah blah. I agree. blah blah.' }
		end

		it 'constructs a new answer' do
			a = @question.answer @params, @user

			a.class.should be Answer
			a.id.should == nil
			a.comment.id.should == nil

			a.save

			a.id.should_not == nil
			a.state.should == 'yes'
			a.user.should == @user
			a.comment.id.should_not == nil
			a.comment.comment.should == 'blah blah. I agree. blah blah.'
		end 
	end

end
