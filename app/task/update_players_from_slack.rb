module Task
    class UpdatePlayersFromSlack
        def process
            Player.all.each do |p|
                p.update_display_names
                p.update_avatars
            end
        end
    end
end