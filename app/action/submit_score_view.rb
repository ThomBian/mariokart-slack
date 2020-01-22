module Action
  class SubmitScoreView
    include Concern::HasPayload

    NB_PLAYERS = 4

    def initialize(params)
      @params = params
    end

    def process
      tmp = sanitize(values)
      puts tmp
    end

    private

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
