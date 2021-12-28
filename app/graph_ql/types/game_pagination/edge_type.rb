module GraphQl
    module Types
        class GamePagination::EdgeType < GraphQl::Types::BaseObject
            field :node, GraphQl::Types::GameType
            field :cursor, String
        end
    end
end