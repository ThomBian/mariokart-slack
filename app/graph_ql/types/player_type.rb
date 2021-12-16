module GraphQl
    class Types::PlayerType < Types::BaseObject
        field :id, ID, null: false
        field :display_name, String, null: false
        field :elo, Integer, null: false
        field :current_rank, Integer, null: false
        field :small_avatar_url, String

        def display_name
            object.display_name || 'No name'
        end
    end
end