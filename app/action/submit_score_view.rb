module Action
  class SubmitScoreView
    include Concern::HasPayload

    NB_PLAYERS = 4

    def initialize(params)
      @params = params
    end

    def process
      Thread.new { puts sorted_values }
    end

    private

    def sorted_values
      sorted_score = game_values.map {|x| x[:score]}.sort.reverse
      with_rank = game_values.map do |x|
        rank = sorted_score.index(x[:score]) + 1
        x.merge(rank: rank)
      end
      with_rank.sort {|a, b| a[:rank] <=> b[:rank]}
    end

    def game_values
      @game_values ||= sanitize(values)
    end

    # @see Command::New#view_content to see form blocks definition
    def sanitize(form_values)
      (1..NB_PLAYERS).map do |player_index|
        {
          username: form_values["player_#{player_index}"]["username_#{player_index}"]['selected_user'],
          score: form_values["score_input_#{player_index}"]["score_value_#{player_index}"]['value']
        }
      end
    end

    def values
      payload["view"]['state']['values']
    end
  end
end
