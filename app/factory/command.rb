module Factory
  class Command
    def initialize(params:)
      @params = params
    end

    def build
      case command
      when 'new'
        ::Command::New.new(params: @params)
      when 'rank'
        ::Command::Rank.new(params: @params)
      when 'my-stats'
        ::Command::MyStats.new(params: @params)
      else
        ::Command::Help.new(params: @params)
      end
    end

    private

    def command
      @command ||= @params['text'].split(' ').first
    end
  end
end
