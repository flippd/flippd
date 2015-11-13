class Comment
  include DataMapper::Resource

  property :videoId, Integer, required: true, key: true
  property :videoTime, Integer, required: false
  # Using a Lambda to make sure this gets evaluated at creation time
  property :commentTime, DateTime, required: true, default: lambda{ |p,s| DateTime.now }
  property :lastEditTime, DateTime, required: false
  property :text, String, required: true

  belongs_to :user
  belongs_to :lastEditUser, 'User', required: false
  belongs_to :parent, 'Comment', requred: false

  # Adds a reply to this comment, and returns the new comment.
  def add_reply user, text
    Comment::create(
      :parent       =>  self,
      :videoId      =>  @videoId,
      :text         =>  text,
      :user         =>  user
    )
  end

end
