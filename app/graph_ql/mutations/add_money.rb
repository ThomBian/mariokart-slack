module GraphQl
    class Mutations::AddMoney < Mutations::BaseMutation
        null true
        argument :player_id, ID

        field :errors, [String], null: false
        field :money, Float, null: false
    
        def resolve(player_id:)
            Player.transaction do
                player = Player.find(player_id)
                return {money: player.money, errors: ['Player has plenty of money, no need to top it up!']} if player.money > 1 
                return {money: player.money, errors: ['Player has already got today\'s money!']} if player.money_last_added_at && player.money_last_added_at > 1.day.ago

                player.update! money: player.money + 5, money_last_added_at: Time.now
                {money: player.money, errors: []}
            end
        end
    end
end