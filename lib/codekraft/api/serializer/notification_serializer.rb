module Codekraft
  module Api
    module Serializer
      class NotificationSerializer < Base

        attributes :description, :sender_avatar_url, :created_at

        def sender_avatar_url
          if Rails.env.production?
            if object.sender.avatar.url.include?("s3.amazonaws")
              "https:#{object.sender.avatar.url.sub("s3.amazonaws", "s3.eu-west-2.amazonaws")}"
            else
              "https://forgemeup-api.herokuapp.com#{object.sender.avatar.url}"
            end
          else
            "http://localhost:3000#{object.sender.avatar.url}"
          end
        end

      end
    end
  end
end
