class Comment 
    include DataMapper::Resource

    property :id, Serial
    property :body, Text, required: true, length: 10000
    property :json_id, String, required: true
    property :created, DateTime, required: true
    property :reply_to, Integer, default: -1

    belongs_to :user
end
