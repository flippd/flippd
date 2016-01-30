require 'json'

module BadgeUtils
     def self.load_badges(json)
        badges = json['badges']
        badge_id = 1
        badges.each do |badge|
            badge["id"] = 1
            badge_id += 1
            # IDs of pages that could trigger an object are below requires
            # Here we pull them out and put them in a new field
            # So that searching for potential rewards is easier
            triggers = []
            badge["requires"].each do |key,req|
                #key is e.g. "videos_watched"
                #req is a list of objects giving id/subreqs (e.g. marks)
                req.each do |req_obj|
                    triggers.push(req_obj["id"])
                end
            end
            badge["triggers"] = triggers
        end
        return badges
    end  

    def self.is_any_trigger(page_id, badges)
        badges.each do |badge|
            if self.triggers(page_id, badge)
                return true
            end
        end
        return false
    end

    def self.triggers(page_id, badge)
        if badge["triggers"].include? page_id
            return true
        end
        return false
    end

    def self.get_triggered_badges(page_id, badges)
        if not self.is_any_trigger(page_id, badges)
            return []
        end
        triggered = []
        badges.each do |badge|
            if self.triggers(page_id, badge)
                triggered.push(badge)
            end
        end
        return triggered
    end
    
    def self.check_requirements(user_id, badge)
        if self.has_badge(user_id, badge)
            return false
        end
        pass = self.check_watched_videos_req(user_id, badge)
        pass = self.check_quiz_result_req(user_id, badge)
        return pass
    end

    def self.has_badge(user_id, badge)
        #User already has badge
        if Badges.get(:user_id => user_id, :json_id => badge["id"])
            return true
        end
        return false
    end

    def self.check_watched_videos_req(user_id, badge)
        #this badge has no videos_watched reqs
        if badge["requires"]["videos_watched"] == nil
            return true
        end
        badge["requires"]["videos_watched"].each do |video|
            #User has any videowatched matching this video_id
            if VideosWatched.get(:user_id => user_id, :json_id => video["id"]).empty?
                return false
            end
        end
        return true
    end

    def self.check_quiz_result_req(user_id, badge)
        #badge has no quiz_result reqs
        if badge["requires"]["quiz_result"] == nil
            return true
        end
        badge["requires"]["quiz_result"].each do |result|
            id = result["id"]
            mark = result["mark"]
            #Any matching result for this quiz for this user is > mark
            if QuizResult.get(:user_id => user_id, :json_id => id, :mark.gt => mark).empty?
                return false
            end
        end
        return true
    end

    def self.award_badge(badge, user_id)
        Badges.create(:json_id => badge["id"], :date => Time.now, :user => user_id)
    end

end
