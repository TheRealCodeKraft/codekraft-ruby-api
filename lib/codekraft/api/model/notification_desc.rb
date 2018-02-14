module Codekraft
  module Api
    module Model
      class NotificationDesc < Base

        has_many :notifications
        has_many :subscriptions

      end
    end
  end
end
