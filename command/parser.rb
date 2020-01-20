module Command
  class Parser
    ALLOWED_COMMAND = %w(new)

    def initialize(params:)
      @params = params
    end

    # @return the parsed command
    #   raise if command is not allowed
    def parse
      return nil unless command.in?(ALLOWED_COMMAND)
      command
    end

    private

    def command
      @command ||= @params[:text]
    end
  end
end
