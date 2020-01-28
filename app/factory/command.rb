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
        ::Command::Rank.new
      else
        raise "Unsupported command #{command}"
      end
    end

    private

    def command
      @command ||= @params['text']
    end
  end
end
