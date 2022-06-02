module Concern
    module Extensions
        module Player::Slack
            def get_or_update_small_avatar
                update_small_avatar(get_profile_from_api['image_24']) unless small_avatar_url.present?
                small_avatar_url
            end
            
            def get_or_update_display_name
                name if name.present?
                update_names
                name
            end

            def update_names
                api_profile = get_profile_from_api
                display_name = api_profile['display_name']
                real_name = api_profile['real_name']
                update_display_names(display_name, real_name)
            end

            def update_avatars
                update_small_avatar(get_profile_from_api['image_24'])
                update_medium_avatar(get_profile_from_api['image_192'])
            end

            private

            def update_small_avatar(new_avatar)
                update! small_avatar_url: new_avatar, small_avatar_url_last_set_at: Time.now
            end

            def update_display_names(new_display_name, new_real_name)
                update! display_name: new_display_name, real_name: new_real_name, display_name_last_set_at: Time.now
            end

            def update_medium_avatar(new_avatar)
                update! medium_avatar_url: new_avatar, medium_avatar_url_last_set_at: Time.now
            end

            def get_profile_from_api
                return @response if defined? @response
                client = ::Slack::Client.new
                response = client.users_info(user: username)
                return nil unless response['ok']
                @response = response['user']['profile']
            end
        end
    end
end