module Concern
  module HasValues
    def values
      @values ||= payload["view"]['state']['values']
    end
  end
end