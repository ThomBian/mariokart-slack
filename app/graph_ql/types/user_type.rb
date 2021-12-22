module GraphQl
    class Types::UserType < Types::BaseObject
        field :id, ID
        field :name, String
        field :authenticated, Boolean

        field :player, Types::PlayerType

        def authenticated
            current_user.present? && object.id === current_user.id
        end
    end
end