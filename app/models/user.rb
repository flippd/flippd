class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String, required: true, length: 150
  property :email, String, required: true, length: 150

  def is_lecturer
    #check for  a dot before the @
    return email.partition("@").first.include? '.'
  end

  def can_edit_comment comment
    return is_lecturer || comment.user == self
  end

end
