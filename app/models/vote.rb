class Vote
    include DataMapper::Resource

    property :id, Serial
    property :comment_id, Integer, required: true
    property :is_upvote, Boolean, required: true

    belongs_to :user
end
