class Game < ActiveRecord::Base
  extend Enumerize

  belongs_to :created_by, class_name: '::Player'
  has_many :games_players, class_name: '::GamesPlayers'
  has_many :players, through: :games_players, class_name: '::Player'

  scope :draft, -> { where(status: :draft) }

  accepts_nested_attributes_for :games_players

  enumerize :status, in: [:draft, :saved]

  def post_summary
    Slack::Client.post_message(
      blocks: [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": ":mario-luigi-dance: A game has just been saved by #{created_by.slack_username}"
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
    elo_rank_lookup = Player.with_rank.index_by(&:username)
    games_players.with_rank_by_score.includes(:player).map do |game_play|
      emoji = Command::Rank::RANK_TO_EMOJI[game_play.rank_value]
      elo_rank = elo_rank_lookup[game_play.player.username].rank_value
      "#{emoji} #{game_play.player.slack_username} #{score_to_emoji(game_play.score)} -  :fleur_de_lis: #{game_play.player.elo} (#{elo_rank})"
    end.join("\n")
  end

  def score_to_emoji(score)
    return ':star2:' if score == 60
    return ':ligue1:' if score >= 35
    return ':ligue2:' if score >= 30
    ':unacceptable:'
  end
end
