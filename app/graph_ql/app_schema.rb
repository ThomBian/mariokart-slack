module GraphQl
    class AppSchema < GraphQL::Schema
        query QueryType

        mutation(Types::MutationType)
    end
end