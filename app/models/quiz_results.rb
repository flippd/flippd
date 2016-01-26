class QuizResult
  include DataMapper::Resource

  property :id, Serial
  property :json_id, Integer, required: true
  property :date, Date, required: true
  property :mark, Integer, required: true

  belongs_to :user
end
