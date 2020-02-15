module Concern
  module HasPayloadParsing
    def payload
      return nil unless has_payload?
      @payload ||= JSON.parse(@params['payload'])
    end

    def action_type
      return nil unless has_payload?
      payload['type']
    end

    def values
      return [] unless view.present?
      @values ||= view['state']['values']
    end

    def block_action
      return nil unless has_payload?
      payload["actions"].first
    end

    def block_action_id
      return nil unless block_action.present?
      block_action['action_id']
    end

    def view
      return nil unless has_payload?
      payload['view']
    end

    def private_metadata
      view['private_metadata'] if view.present?
    end

    def view_callback_id
      view['callback_id'] if view.present?
    end

    def command_sent_by_user_id
      return nil unless has_payload?
      payload['user']['id']
    end

    def message_ts
      return nil unless has_payload?
      payload['message']['ts']
    end

    def trigger_id
      return nil unless has_payload?
      payload['trigger_id']
    end

    private

    def has_payload?
      @payload || @params['payload']
    end
  end
end
