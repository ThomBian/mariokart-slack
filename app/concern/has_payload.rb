module Concern
  module HasPayload
    def payload
      @payload ||= JSON.parse(@params['payload'])
    end
  end
end
