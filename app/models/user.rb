class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String, required: true, length: 150
  property :email, String, required: true, length: 150

  has n, :badges
  has n, :videos_watched
  has n, :quiz_results
  has n, :comments
end
