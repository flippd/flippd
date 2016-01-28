require 'json'

module BadgeUtils
     def load_badges(json)
        badges = json['badges']
        badge_id = 1
        badges.each do |badge|
            badge["id"] = 1
            badge_id += 1
        end
        return badges
    end    
end
