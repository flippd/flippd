class Badge
  include DataMapper::Resource

  property :id, Serial
  property :json_id, Integer
  property :date, Date

  belongs_to :user
end
