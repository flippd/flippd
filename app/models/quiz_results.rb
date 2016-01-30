class QuizResult
  include DataMapper::Resource

  property :id, Serial
  property :json_id, String, required: true
  property :date, Date, required: true
  property :mark, Integer, required: true

  belongs_to :user
end
