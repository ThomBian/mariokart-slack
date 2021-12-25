module GraphQl
    class Mutations::AddMoney < Mutations::BaseMutation
        null true
        argument :money_option_id, ID

        field :errors, [String], null: false
        field :money_option, Types::MoneyOptionType
    
        def resolve(money_option_id:)
            return {money_option: nil, errors: ['Oops, something went wrong... (not signed in)']} if current_user.nil?
            return {money_option: nil, errors: ['Oops, something went wrong... (never played)']} if current_user.player.nil?

            player = current_user.player
            option = MoneyOption.find(money_option_id)
            return {money_option: nil, errors: ['Oops, something went wrong... (option not available)']} if !option.active

            return {money_option: nil, errors: ['Oops, something went wrong... (option free already got)']} if option.free? && player.already_got_free_option_today?
            
            MoneyOption.transaction do
                player.money_options << option
                player.update money: player.money + option.value
            end

            return { money_option: option, errors: [] }
        end
    end
end