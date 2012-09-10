module Ananta
	module Vote

		# Cast a vote 
		# vote: for, against, cancel
		# cuid: <user_id>
		def cast_vote= opts
			case opts[:vote]
			when 'for'
				vote = "vote_exclusively_for"
			when 'against'
				vote = "vote_exclusively_against"
			when 'cancel'
				vote = "unvote_for"
			end
			puts User.find(opts[:cuid]).send(vote, self).inspect rescue nil
		end 

	end
end