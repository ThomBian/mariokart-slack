module GraphQl
    module Types
        class GamePagination::ResultType < GraphQl::Types::BaseObject
            field :total_count, Int
            field :edges, [GamePagination::EdgeType]
            field :page_info, GamePagination::PageInfoType
        end
    end
end