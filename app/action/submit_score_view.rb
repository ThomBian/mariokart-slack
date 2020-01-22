module Action
  class SubmitScoreView
    include Concern::HasPayload

    NB_PLAYERS = 4

    def initialize(params)
      @params = params
    end

    def process
      puts game_values
      puts new_elos
    end

    private

    def new_elos
      new_elos = {}
      game_values.each do |x|
        new_elo = x[:elo]
        game_values.each do |y|
          next if x[:username] == y[:username]
          outcome = game_outcome(x[:score], y[:score])
          new_elo_diff = ::Concern::Elo.new(x[:elo], y[:elo], outcome).compute_diff
          new_elo += new_elo_diff
        end
        new_elos[x[:username]] = round(new_elo)
      end
    end

    def game_outcome(score_a, score_b)
      return :draw if score_a == score_b
      return :win if score_a > score_b
      :loose
    end

    def sorted_values
      sorted_score = game_values.map {|x| x[:score]}.sort.reverse
      with_rank = game_values.map do |x|
        rank = sorted_score.index(x[:score]) + 1
        x.merge(rank: rank)
      end
      with_rank.sort {|a, b| a[:rank] <=> b[:rank]}
    end

    def game_values
      @game_values ||= sanitize(values).map {|x| x.merge(elo: rand(800..1200))}
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

    def round(f)
      f.round(2)
    end
  end
end
