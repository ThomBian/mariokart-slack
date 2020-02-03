class Game
  attr_reader :created_by

  def initialize(results, created_by, players)
    @results = results
    @created_by = created_by
    @players = players
  end

  def post_summary
    Slack::Client.post_message(
      blocks: [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": ":mario-luigi-dance: A game has just been saved by <@#{@created_by}>"
                  }
                },
                {
                  type: "section",
                  text: {
                    type: "mrkdwn",
                    text: summary_text
                  }
                }
              ]
    )
  end

  private

  def summary_text
    players_by_username = @players.index_by(&:username)
    elo_rank_lookup = Player.with_rank.index_by(&:username)
    summary.map do |result|
      emoji = Command::Rank::RANK_TO_EMOJI[result[:rank]]
      player = players_by_username[result[:username]]
      elo_rank = elo_rank_lookup[result[:username]].rank_value
      "#{emoji} <@#{player.username}> #{score_to_emoji(result[:score])} -  :fleur_de_lis: #{player.elo} (#{elo_rank})"
    end.join("\n")
  end

  def summary
    sorted_score = @results.map {|x| x[:score]}.sort.reverse
    with_rank = @results.map do |x|
      rank = sorted_score.index(x[:score]) + 1
      x.merge(rank: rank)
    end
    with_rank.sort {|a, b| a[:rank] <=> b[:rank]}
  end

  def score_to_emoji(score)
    return ':star2:' if score == 60
    return ':ligue1:' if score >= 35
    return ':ligue2:' if score >= 30
    ':unacceptable:'
  end
end
