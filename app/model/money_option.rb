class MoneyOption < ActiveRecord::Base
    has_many :players_money_options, class_name: '::PlayersMoneyOptions'
    has_many :players, through: :players_money_options, class_name: '::Player'

    scope :free, -> {where(price: 0)}
    scope :active, -> {where(active: true)}

    def free?
        price == 0
    end
end