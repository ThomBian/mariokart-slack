require_relative './has_payload'

module Concern
  module HasBlockAction
    include Concern::HasPayload

    def block_action
      payload["actions"].first
    end
  end
end