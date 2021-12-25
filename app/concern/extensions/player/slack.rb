module Concern
    module Extensions
        module Player::Slack
            def get_or_load_small_avatar
                save_small_avatar(get_profile_from_api['image_24']) if need_to_save_small_avatar?
                small_avatar_url
            end
            
            def get_or_load_medium_avatar
                save_medium_avatar(get_profile_from_api['image_192']) if need_to_save_medium_avatar?
                medium_avatar_url
            end
            
            def get_or_load_display_name
                name unless need_to_save_display_name?
                api_profile = get_profile_from_api
                display_name = api_profile['display_name']
                real_name = api_profile['real_name']
                save_display_names(display_name, real_name)
                name
            end

            private

            def save_small_avatar(new_avatar)
                update! small_avatar_url: new_avatar, small_avatar_url_last_set_at: Time.now
            end

            def save_display_names(new_display_name, new_real_name)
                update! display_name: new_display_name, real_name: new_real_name, display_name_last_set_at: Time.now
            end

            def save_medium_avatar(new_avatar)
                update! medium_avatar_url: new_avatar, medium_avatar_url_last_set_at: Time.now
            end

            def get_profile_from_api
                return @response if defined? @response
                client = ::Slack::Client.new
                response = client.users_info(user: username)
                return nil unless response['ok']
                @response = response['user']['profile']
            end

            def need_to_save_small_avatar?
                small_avatar_url.blank? || small_avatar_url_last_set_at.blank? || small_avatar_url_last_set_at <= 1.day.ago.utc
            end

            def need_to_save_display_name?
                display_name.blank? || display_name_last_set_at.blank? || display_name_last_set_at <= 1.day.ago
            end

            def need_to_save_medium_avatar?
                medium_avatar_url.blank? || medium_avatar_url_last_set_at.blank? || medium_avatar_url_last_set_at <= 1.day.ago
            end
        end
    end
end