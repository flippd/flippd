module PhaseUtils
    def load_phases(json)
        # The configuration doesn't have to include identifiers, so we
        # add an identifier to each phase, video and quiz
        phase_id = 1
        video_quiz_id = 1
        phases = json["phases"]
        phases.each do |phase|
            phase["id"] = phase_id
            phase_id += 1
            
            phase["topics"].each do |topic|
            # The configuration doesn't have to include quizzes for every topic,
            # so we add an empty list of quizzes to the ones that don't
                if topic["quizzes"] == nil
                    topic["quizzes"] = []
                end

                topic['videos'].each do |video|
                    video["id"] = video_quiz_id
                    video["type"] = "videos"
                    video_quiz_id += 1
                end

                topic["quizzes"].each do |quiz|
                    quiz['id'] = video_quiz_id
                    quiz['type'] = "quizzes"
                    video_quiz_id += 1
                end
            end
        end
        return phases
    end

    def get_by_id(phases, id)
        phases.each do |phase|
            phase['topics'].each do |topic|
                topic['videos'].each do |video|
                  if video["id"] == id
                    return video
                  end
                end

               # If a video with the matching ID was not found,
               # the ID must correspond to a quiz
               topic['quizzes'].each do |quiz|
                 if quiz["id"] == id
                   return quiz
                 end
               end
            end
        end
        return nil
    end
end
