module Task
    class UpdatePlayersFromSlack
        def process
            Player.all.each do |p|
                p.get_or_load_display_name
                p.get_or_load_medium_avatar
                p.get_or_load_small_avatar
            end
        end
    end
end