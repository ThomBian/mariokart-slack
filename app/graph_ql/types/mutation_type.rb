module GraphQl
    class Types::MutationType < Types::BaseObject
        field :add_money, mutation: Mutations::AddMoney
    end
end