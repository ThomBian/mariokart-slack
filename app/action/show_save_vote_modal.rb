module Action
    class ShowSaveVoteModal
        include Concern::HasPayloadParsing
        include Concern::ServerResponse

        def initialize(params)
            @params = params
        end

        def process
            return post_already_voted_message if voter.has_already_voted?(games_players.game)

            @client = Slack::Client.new
            @client.views_open(view_payload)
            response_ok_basic
        end

        private

        def post_already_voted_message
            Slack::Client.post_ephemeral_message(
                text: "You have already voted! :eyes:",
                user: command_sent_by_user_id,
                channel_id: ENV['CHANNEL_ID']
            )
            response_ok_basic
        end

        def games_players
            @games_players ||= ::GamesPlayers.find(block_action_value.to_i)
        end

        def view_payload
            {
                token: @client.token,
                trigger_id: trigger_id,
                view: view_content
            }
        end

        def private_metadata
            {
                game_player_id: games_players.id,
                response_url: response_url
            }.to_json.to_s
        end

        def view_content
            {
                "type": "modal",
                "callback_id": ::Factory::ViewSubmission::SAVE_VOTE_CALLBACK_ID,
                "private_metadata": private_metadata,
                "notify_on_close": true,
                "title": {
                    "type": "plain_text",
                    "text": "Place your bet!",
                    "emoji": true
                },
                "submit": {
                    "type": "plain_text",
                    "text": "Vote",
                    "emoji": true
                },
                "close": {
                    "type": "plain_text",
                    "text": "Cancel",
                    "emoji": true
                },
                blocks: blocks
            }
        end

        INPUT_ID = 'amount-of-money'
        def blocks
            [
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": "You are voting for #{in_game_player.get_or_update_display_name}.\nThe odd is *#{games_players.odd}*.",
                    }
                },
                {
                    "type": "input",
                    "block_id": INPUT_ID,
                    "element": {
                        "type": "plain_text_input",
                        "action_id": INPUT_ID
                    },
                    "label": {
                        "type": "plain_text",
                        "text": "Amount of money",
                        "emoji": true
                    }
                },
                {
                    "type": "section",
                    "text": {
                        "type": "plain_text",
                        "text": "You have #{voter.money.round(2)} $Պ.",
                        "emoji": true
                    }
                }
            ]
        end

        def voter
            @voter ||= ::Player.find_or_create_by(username: command_sent_by_user_id) 
        end

        def in_game_player
            @in_game_player ||= games_players.player
        end
    end
end