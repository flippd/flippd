module PhaseUtils
    def load_phases(json)
        # The configuration doesn't have to include identifiers, so we
        # add an identifier to each phase, video and quiz
        phase_pos = 1
        video_quiz_pos = 1
        phases = json["phases"]
        phases.each do |phase|
            phase["pos"] = phase_pos
            phase_pos += 1
            
            phase["topics"].each do |topic|
            # The configuration doesn't have to include quizzes for every topic,
            # so we add an empty list of quizzes to the ones that don't
                if topic["quizzes"] == nil
                    topic["quizzes"] = []
                end

                topic['videos'].each do |video|
                    video["pos"] = video_quiz_pos
                    video["type"] = "videos"
                    video_quiz_pos += 1
                end

                topic["quizzes"].each do |quiz|
                    quiz['pos'] = video_quiz_pos
                    quiz['type'] = "quizzes"
                    video_quiz_pos += 1
                end
            end
        end
        return phases
    end

    def get_by_pos(phases, pos)
        return get_by_key_val(phases, "pos", pos)
    end

    def get_by_id(phases, id)
        return get_by_key_val(phases, "id", id)
    end

    def get_by_key_val(phases, key, val)
        phases.each do |phase|
            phase['topics'].each do |topic|
                topic['videos'].each do |video|
                  if video[key] == val
                    return video
                  end
                end

               # If a video with the matching ID was not found,
               # the ID must correspond to a quiz
               topic['quizzes'].each do |quiz|
                 if quiz[key] == val
                   return quiz
                 end
               end
            end
        end
        return nil
    end
end
