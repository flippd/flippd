class QuizResult
  include DataMapper::Resource

  property :id, Serial
  property :json_id, Integer
  property :date, Date
  property :mark, Integer

  belongs_to :user
end
