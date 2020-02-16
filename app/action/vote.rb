module Action
  class Vote
    include ::Concern::HasPayloadParsing
    include ::Concern::OngoingBlocks

    def initialize(params)
      @params = params
    end

    def process
      gp = ::GamesPlayers.find(block_action_value.to_i)
      voted_by = ::Player.find_or_create_by(username: command_sent_by_user_id)

      return post_already_voted_message if has_already_voted?(gp.game, voted_by)

      ::Vote.create!({
                         games_players: gp,
                         game: gp.game,
                         voted_by: voted_by
                     })

      response = post_has_voted(gp)
      response['ok']
    end

    private

    def post_already_voted_message
      Slack::Client.post_ephemeral_message(
          text: "You have already voted! :eyes:",
          user: command_sent_by_user_id,
          channel_id: ENV['CHANNEL_ID']
      )
    end

    def has_already_voted?(game, voted_by)
      ::Vote.where(game: game, voted_by: voted_by).none?
    end

    def post_has_voted(game_player)
      HTTParty.post(response_url, {
          body: {
              replace_original: true,
              blocks: ongoing_blocks(game_player.game)
          }.to_json,
          headers: {'Content-Type' => 'application/json'}
      })
    end
  end
end