class Flippd < Sinatra::Application

  ["/comment/new", "/comment/edit/:id", "/comment/delete/:id"].each do |path|
    before path do
      unless @user
        halt 401, "Error 401, Unauthorised"
      end

      if params[:id]
        comment = Comment.get params[:id]
        unless @user.can_edit_comment comment
          halt 403, "Error 403, Forbidden"
        end
      end
    end
  end

  post '/comment/new' do

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

    # Collects the POST params
    text = params[:new_text]
    comment = Comment.get(params[:id])

    # Edits the comment
    comment.edit_comment @user, text

    # Redirects to the video page
    redirect('/videos/' + comment.videoId.to_s)

  end

  post '/comment/delete/:id' do

    # Collects the POST params
    comment = Comment.get(params[:id])

    # Deletes the comment
    comment.delete_comment @user

    # Redirects to the video page
    redirect('/videos/' + comment.videoId.to_s)

  end



end
