module Command
  class Stats
    STATS = [
      ::Stat::Rank,
      ::Stat::Elo::Highest,
      ::Stat::Elo::Current,
      ::Stat::Elo::Lowest,
      ::Stat::Score::Avg,
      ::Stat::Score::Performances,
      ::Stat::GamePlayed,
      ::Stat::Vote,
      ::Stat::Money
    ]

    def initialize(params:)
      @params = params
    end

    def process
      return post_no_stat_message unless player.present?
      post_stats_message
    end

    private

    def post_no_stat_message
      ::Slack::Client.
        post_direct_message(text: ":blueshell: You have never played! I can't have stats though...", users: username)
    end

    def username
      @params['user_id']
    end

    def player
      @player ||= Player.where(username: username).first
    end

    def post_stats_message
      ::Slack::Client.
        post_direct_message(blocks: stats_blocks, users: username)
    end

    def stats_blocks
      [
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": ":mega: *YOUR STATS* :mega:"
          }
        },
        {
          "type": "context",
          "elements": [
                    {
                      "text": "*#{Date.current}*",
                      "type": "mrkdwn"
                    }
                  ]
        },
        {
          "type": "divider"
        },
        {
          "type": "section",
          "fields": stat_fields
        },
        {
          "type": "divider"
        },
        {
          "type": "context",
          "elements": [
                    {
                      "type": "mrkdwn",
                      "text": "Keep going! You are doing great!!"
                    }
                  ]
        }
      ]
    end

    def stat_fields
      stats.map do |stat|
        {
          "type": "mrkdwn",
          "text": stat.markdown,
        }
      end
    end

    def stats
      STATS.map do |klass|
        klass.new(player)
      end
    end
  end
end