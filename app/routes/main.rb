require 'open-uri'
require 'json'
require 'sinatra/base'
require './app/helpers/badge_utils'
require './app/helpers/phase_utils'

class Flippd < Sinatra::Application
	helpers BadgeUtils, PhaseUtils

	before do
	    @session = session
	    # Load in the configuration (at the URL in the project's .env file)
	    @json_loc = ENV['CONFIG_URL'] + "module.json"
    	@module = JSON.load(open(@json_loc))
	    # From helpers/phase_utils
	    @phases = load_phases(@module)
	    # From helpers/badge_utils
	    @badges = BadgeUtils.load_badges(@module)
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
    
end
