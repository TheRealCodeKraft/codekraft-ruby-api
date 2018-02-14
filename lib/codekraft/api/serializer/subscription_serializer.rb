module Codekraft
  module Api
    module Serializer

      class SubscriptionSerializer < Base

        attributes :id, :notification_desc, :mobile_push, :email_push

        def user
          UserSerializer.new(object.user, {root: false})
        end

        def notification_desc
          NotificationDescSerializer.new(object.notification_desc, {root: false})
        end

      end

    end
  end
end
