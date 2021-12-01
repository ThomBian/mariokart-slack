module Dml
    class CreateAchievements
      def self.migrate
        Achievement.create(name: '1st place', emoji: ':one:')
        Achievement.create(name: '2nd place', emoji: ':two:')
        Achievement.create(name: '3rd place', emoji: ':three:')

        Achievement.create(name: 'Most games', emoji: ':space-invader:')

        Achievement.create(name: 'Most correct votes', emoji: ':magic_wand:')
      end
    end
  end