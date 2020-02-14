module Concern
  module HasApiParsing
    def channel_id
      @params['channel_id'] || ENV['CHANNEL_ID']
    end

    def user_id
      @params['user_id']
    end
  end
end