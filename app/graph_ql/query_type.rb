module GraphQl
    class QueryType < GraphQL::Schema::Object
        description "The query root of this schema"

        field :games, Types::GamePagination::ResultType, "Returns a page of games" do
            argument :cursor, String, required: false, default_value: Time.now
        end

        field :players, [Types::PlayerType], "Returns all players", null: false

        field :player, Types::PlayerType, "Returns a player" do
            argument :id, String
        end
        
        field :achievements, [Types::AchievementType], "Return all achievements", null: false

        field :current_user, Types::UserType, "Return the current user", null: false

        field :money_options, [Types::MoneyOptionType], "Return all options", null: false

        def games(first: 5, cursor:)
            cursor ||= Time.now
            games = ::Game.includes(games_players: [:player, votes: :voted_by])
                .where('created_at < ?', cursor)
                .order('created_at DESC')
                .limit(first)
                .all
            start_cursor = games.last.created_at
            has_next_page = ::Game.where('created_at < ?', start_cursor).count > 0
            edges = games.map {|g| { node: g, cursor: g.created_at }}
            total_count = ::Game.all.count
            return {
                total_count: total_count,
                edges: edges,
                page_info: {
                    start_cursor: start_cursor,
                    has_next_page: has_next_page
                }
            }
        end

        def players
            Player.includes(:achievements).with_rank.all
        end

        def player(id:)
            Player.includes(players_achievements: [:achievement, :season]).find(id)
        end

        def achievements
            Achievement.all.order(:id)
        end

        def current_user
            return {} unless context[:current_user].present?
            context[:current_user]
        end

        def money_options
            MoneyOption.active.all.order(:value)
        end 
    end
end