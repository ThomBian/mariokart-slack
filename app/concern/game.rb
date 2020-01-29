module Concern
  class Game
    NB_PLAYERS = 4

    attr_reader :created_by

    def initialize(values, created_by)
      @values = values
      @created_by = created_by
    end

    # @see Command::New#view_content to see form blocks definition
    def results
      @results ||= (1..NB_PLAYERS).map do |player_index|
        {
          username: @values["player_#{player_index}"]["username_#{player_index}"]['selected_user'],
          score: @values["score_input_#{player_index}"]["score_value_#{player_index}"]['value']
        }
      end
    end

    def summary
        sorted_score = results.map {|x| x[:score]}.sort.reverse
        with_rank = results.map do |x|
          rank = sorted_score.index(x[:score]) + 1
          x.merge(rank: rank)
        end
        with_rank.sort {|a, b| a[:rank] <=> b[:rank]}
    end
  end
end
