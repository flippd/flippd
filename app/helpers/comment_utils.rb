
module CommentUtils

	def get_comments(video_id, voting_on):
		get_replies(video_id, voting_on, -1)
	end

	def get_replies(video_id, voting_on, replying_to=-1):
		if voting_on
			order = [ :points.desc ]
		else
			order = [ :created.asc ]
		end
		Comment.all(:json_id => video_id, :order => order, :reply_to => replying_to)
	end

	def get_current_vote(comment_id, user)
		vote = Vote.first(:comment_id => comment_id, :user => user)
		if vote
			return vote.is_upvote
		else
			return nil
		end
	end

end
