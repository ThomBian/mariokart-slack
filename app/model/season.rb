class Season < ActiveRecord::Base
    has_many :games, class_name: '::Game'
    has_many :players_achievements, class_name: '::PlayersAchievements'
    has_many :players, -> { distinct }, through: :games, class_name: '::Player'
    has_many :games_players, through: :games, class_name: '::GamesPlayers'
    has_many :votes, through: :games, class_name: '::Vote'

    scope :current, -> { where(is_current: true).first }
    scope :last_one, -> { where(id: Season.current.id - 1) }

    def number_of_games
        games.count
    end

    def number_of_players
        players.count
    end

    def number_of_correct_votes
        votes.winners.count
    end

    def top_players(rank = 5)
        players.ordered_by_elo.limit(rank)
    end

    def most_games_players
        return [] if games_players.count <= 0

        players_ids = games_per_players.select {|k, v| v == max_games_played }.keys
        players.where(id: player_ids)
    end

    def max_games_played
        @max ||= games_per_players.values.max || 0
    end

    def most_correct_votes_players
        return [] if correct_votes_per_players.empty?

        player_ids = correct_votes_per_players.select {|k, v| v == max_correct_votes }.keys
        players.where(id: player_ids)
    end

    def max_correct_votes
        @max_correct_votes ||= correct_votes_per_players.values.max || 0
    end

    private

    def games_per_players
        @games_per_players ||= games_players.count <= 0 ? {} : games_players.group(:player_id).count
    end

    def correct_votes_per_players
        @correct_votes_per_player ||= votes.winners.group(:voted_by).count
    end
end