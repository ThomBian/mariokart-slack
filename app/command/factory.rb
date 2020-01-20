require_relative 'parser'
require_relative 'new'

module Command
  class Factory
    def initialize(params:)
      @params = params
    end

    def build
      parser = Command::Parser.new(params: @params)
      case parser.parse
      when 'new'
        Command::New.new(params: @params)
      else
        nil
      end
    end
  end
end
