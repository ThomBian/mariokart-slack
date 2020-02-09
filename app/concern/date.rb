module Concern
  module Date
    def weekend?
      ::Date.current.saturday? || ::Date.current.sunday?
    end
  end
end