module GraphQl
    class Types::MoneyOptionType < Types::BaseObject
        field :id, ID, null: false
        field :title, String, null: false
        field :value, Integer, null: false
        field :price, Float, null: false
    end
end