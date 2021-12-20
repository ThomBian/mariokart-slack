module GraphQl
    class Types::DataPointType < Types::BaseObject
        field :x, String, null: false
        field :y, String, null: false
    end
end