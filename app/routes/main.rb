require 'open-uri'
require 'json'
require 'sinatra/base'
require './app/helpers/badge_utils'
require './app/helpers/phase_utils'

class Flippd < Sinatra::Application
  helpers BadgeUtils, PhaseUtils

  before do
    @session = session
    if session.has_key?("user_id")
        @user_id = session["user_id"]
    else
        @user_id = nil
    end
    # Load in the configuration (at the URL in the project's .env file)
    @json_loc = ENV['CONFIG_URL'] + "module.json"
    @module = JSON.load(open(@json_loc))
    # From helpers/phase_utils
    @phases = load_phases(@module)
    # From helpers/badge_utils
    @badges = BadgeUtils.load_badges(@module)
    
    if !(flash[:notification])
        flash[:notification] = {}
    end
  end

  get '/' do
    erb open(ENV['CONFIG_URL'] + "index.erb").read
  end

  get '/phases/:title' do
    @phase = nil
    @phases.each do |phase|
      @phase = phase if phase['title'].downcase.gsub(" ", "_") == params['title']
    end

    pass unless @phase
    erb :phase
  end
    
  get '/videos/:pos' do
    pos = params["pos"].to_i
    @phases.each do |phase|
      phase['topics'].each do |topic|
        topic['videos'].each do |video|
          # Set the current video
          if video["pos"] == pos
            @phase = phase
            @video = video
          end
        end
      end
    end

    # Get the next and previous video/quiz to link to
    @previous = get_by_pos(@phases, pos-1)
    @next = get_by_pos(@phases, pos+1)

    # Load the comments for this video
    @comments = Comment.all(:json_id => @video["id"], :order => [ :created.desc ], :reply_to => -1)

    @replies = Array.new
    @comments.each do |comment|
        @replies[comment["id"]] = Comment.all(:json_id => @video["id"], :order => [ :created.asc ], :reply_to => comment["id"])
    end
    
    # Mark this video as unwatched - we will correct this if necessary
    @video_watched = false
    
    # Check if a user is logged in
    if session.has_key?("user_id")
      user_id = session['user_id']
      
      # If a user is logged in we will check if they have watched this video before
      matches = VideosWatched.first(:user_id => user_id, :json_id => @video["id"])
      if matches != nil
        @video_watched = true
      end
    end

    pass unless @video
    erb :video
  end

  get '/quizzes/:pos' do
    pos = params["pos"].to_i
    @phases.each do |phase|
      phase['topics'].each do |topic|
        topic['quizzes'].each do |quiz|
          #Set the current quiz
          if quiz["pos"] == pos
            @phase = phase
            @quiz = quiz
          end
        end
      end
    end

    # Get the next and previous video/quiz to link to
    @previous = get_by_pos(@phases, pos-1)
    @next = get_by_pos(@phases, pos+1)

    pass unless @quiz
    erb :quiz
  end

  get '/notification_alert' do
    erb :notification_alert, :layout => false
  end

  post '/post_comment/:id' do
    video_id = params["id"]
    body = params[:body]

    if session.has_key?("user_id")
      @user = User.get(session['user_id'])

      if params[:replyID]
        Comment.create(:body => body, :json_id => video_id, :created => DateTime.now, :user => @user, :reply_to => params[:replyID])
      else
        Comment.create(:body => body, :json_id => video_id, :created => DateTime.now, :user => @user)
      end

      origin = env["HTTP_REFERER"] || '/'
      redirect to(origin)
    else
      status 500
      return "Error: User not logged in."
    end
  end

  post '/remove_comment/:id' do
    comment_id = params["id"]

    if session.has_key?("user_id")
      user = User.get(session['user_id'])
      comment = Comment.first(:id => comment_id.to_i, :user => user)

      if comment
        comment.destroy
        origin = env["HTTP_REFERER"] || '/'
        redirect to(origin)
      else
        status 500
        return "Error: You can only remove your own comments."
      end

    else
      status 500
      return "Error: User not logged in."
    end
  end
end
