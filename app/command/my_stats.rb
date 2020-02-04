module Command
  class MyStats
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
        post_direct_message(text: ":blueshell: Here you go: #{player.elo}", users: username)
    end
  end
end