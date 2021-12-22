module GraphQl
    class Types::BaseObject < GraphQL::Schema::Object
        def current_user
            context[:current_user]
        end
    end
end