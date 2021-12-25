class PlayersMoneyOptions < ActiveRecord::Base
    belongs_to :player, class_name: '::Player'
    belongs_to :money_option, class_name: '::MoneyOption'

    scope :free, -> {joins(:money_option).where(money_option: {price: 0})}
end