class Badge
  include DataMapper::Resource

  property :id, Serial
  property :json_id, String
  property :date, Date

  belongs_to :user
end
