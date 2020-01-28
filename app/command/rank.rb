module Command
  class Rank
    def process
      @client  = Slack::Client.new(ENV['BOT_ACCESS_TOKEN'])
      response = @client.chat_postMessage(list_payload)
      response['ok']
    end

    private

    def list_payload
      {
        token:   @client.token,
        channel: ENV['CHANNEL_ID'],
        blocks:  [
                   {
                     "type": "section",
                     "text": {
                       "type": "mrkdwn",
                       "text": "Ranking season 1"
                     }
                   },
                   {
                     type: "section",
                     text: {
                       type: "mrkdwn",
                       text: ranking_text
                     }
                   }
                 ]
      }
    end

    def ranking_text
      Player.with_rank.ordered_by_elo.map do |player|
         "#{player.rank_value}. #{player.slack_username} (#{player.elo})"
      end.join('\n')
    end
  end
end