module Serializer
  module Elo
    def save_new_elos(new_elos)
      new_elos.each do |new_elo|
        # player = Player.find_by(new_elo[:username])
        # player.update! elo: new_elo[:value]
        puts "#{new_elo[:username]} - #{new_elo[:value]}"
      end
    end
  end
end
