module Action
  class SubmitScoreView
    include Concern::HasPayload

    NB_PLAYERS = 4

    def initialize(params)
      @params = params
    end

    def process
      puts game_results
      puts '###########'
      puts new_elos
    end

    private

    def new_elos
      new_elos = {}
      game_results.each do |result|
        current_elo = player_elos[result[:username]]
        new_elo = current_elo
        game_results.each do |other_player_result|
          next if result[:username] == other_player_result[:username]
          other_player_elo = player_elos[other_player_result[:username]]
          outcome = game_outcome(result[:score], other_player_result[:score])
          new_elo_diff = ::Concern::Elo.new(current_elo, other_player_elo, outcome).compute_diff
          puts "#{result[:username]}(#{current_elo}) vs #{other_player_result[:username]}(#{other_player_elo}) [#{outcome}]-> #{new_elo_diff}"
          new_elo += new_elo_diff
        end
        new_elos[result[:username]] = round(new_elo)
      end
      new_elos
    end

    def game_outcome(score_a, score_b)
      return :draw if score_a == score_b
      return :win if score_a > score_b
      :loose
    end

    def sorted_values
      sorted_score = game_results.map {|x| x[:score]}.sort.reverse
      with_rank = game_results.map do |x|
        rank = sorted_score.index(x[:score]) + 1
        x.merge(rank: rank)
      end
      with_rank.sort {|a, b| a[:rank] <=> b[:rank]}
    end

    def game_results
      @game_results ||= sanitize(values)
    end

    def player_elos
      @elo = {}
      game_results.each do |result|
        @elo[result[:username]] = rand(800..1200)
      end
      @elo
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
