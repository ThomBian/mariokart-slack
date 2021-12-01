module Dml
    class CreateAchievements
      def self.migrate
        Achievement.create(name: '1st place', emoji: ':crown:')
        Achievement.create(name: '2nd place', emoji: ':dolphin:')
        Achievement.create(name: '3rd place', emoji: ':wood:')

        Achievement.create(name: 'Most games', emoji: ':joystick:')

        Achievement.create(name: 'Most correct votes', emoji: ':four_leaf_clover:')
      end
    end
  end