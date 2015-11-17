class Flippd < Sinatra::Application

  post '/comment/new' do
    unless @user
      halt 401, "Error 401, Unauthorised"
    end

    # Get the parameters from the form
    @text = params[:text]
    @videoId = params[:videoId]

    @videoTime = nil
    if params[:videoTimeMinutes] && params[:videoTimeSeconds]
      @videoTime = (params[:videoTimeMinutes].to_i * 60) + params[:videoTimeSeconds].to_i
    end

    # Create the new comment
    Comment.create(
      :videoId => @videoId,
      :user => @user,
      :text => @text,
      :videoTime => @videoTime
    )

    # Redirect the user back to the video page
    redirect('/videos/' + @videoId)
  end

  post '/comment/edit/:id' do
    unless @user
      halt 401, "Error 401, Unauthorised"
    end

    #@todo Allow the author of comment to edit
    unless @user.is_lecturer #or the auther
      halt 403, "Error 403, Forbidden"
    end
  end

end
