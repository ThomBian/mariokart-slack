module Concern
    module Extensions
        module Player::Money
            def update_money!(vote)
                update money: money + vote.earnings
            end

            def already_got_free_option_today?
                last_paid_free_option.present? && last_paid_free_option.created_at > 1.day.ago.utc
            end

            def last_paid_free_option
                @option ||= paid_free_options.order(created_at: :desc).last
            end

            def paid_free_options
                players_money_options.includes(:money_option).free
            end
        end
    end
end