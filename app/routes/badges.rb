require 'sinatra/base'
require './app/helpers/badge_utils'
require 'time'

class Flippd < Sinatra::Application
    helpers BadgeUtils

    before do
        @session = session
        @user_id = nil
        if session.has_key?("user_id")
            @user_id = session["user_id"]
        end
        @json_loc = ENV['CONFIG_URL'] + "module.json"
        @module = JSON.load(open(@json_loc))
        @badges = BadgeUtils.load_badges(@module)
    end

    #only accessible if logged in, as link is in user profile dropdown
    get '/badges/my_badges' do
        @earnt = []
        @not_earnt = []
        @total_badges = @badges.length
        @badges.each do |badge|
            if BadgeUtils.has_badge(@user_id, badge)
                #add date earnt to badge data struct
                badge["date"] = BadgeUtils.get_date_earned(@user_id, badge).strftime("%A %-d %B %Y")
                @earnt.push(badge)
            else
                @not_earnt.push(badge)
            end
        end
        erb :badges
    end


end
