module GraphQl
    module Types
        class GamePagination::PageInfoType < GraphQl::Types::BaseObject
            field :start_cursor, String
            field :has_next_page, Boolean
        end
    end
end