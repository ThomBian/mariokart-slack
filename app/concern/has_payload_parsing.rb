module Concern
  module HasPayloadParsing
    def payload
      @payload ||= JSON.parse(@params['payload'])
    end

    def action_type
      payload['type']
    end

    def values
      return [] unless view.present?
      @values ||= view['state']['values']
    end

    def block_action
      payload["actions"].first
    end

    def block_action_id
      block_action['action_id']
    end

    def view
      payload['view']
    end

    def private_metadata
      view['private_metadata'] if view.present?
    end

    def view_callback_id
      view['callback_id'] if view.present?
    end

    def command_sent_by_user_id
      payload['user']['id']
    end

    def message_ts
      payload['message']['ts']
    end

    def trigger_id
      payload['trigger_id']
    end
  end
end
