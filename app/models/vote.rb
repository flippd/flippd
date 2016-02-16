class Vote
    include DataMapper::Resource

    property :id, Serial
    property :comment_id, Integer, required: true
    property :is_upvote, Boolean, required: true
    property :json_id, String, required: true

    belongs_to :user
end
