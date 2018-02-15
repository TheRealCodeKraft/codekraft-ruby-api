module Codekraft
  module Api
    module Serializer
      class AttachmentSerializer < Base

        attributes :id, :file_url, :created_at, :updated_at

        def file_url
          if Rails.env.production?
            if object.attachment.url.include?("s3.amazonaws")
              "https:#{object.attachment.url.sub("s3.amazonaws", "s3.eu-west-2.amazonaws")}"
            else
              "https://forgemeup-api.herokuapp.com#{object.attachment.url}"
            end
          else
            "http://localhost:3000#{object.attachment.url}"
          end
        end

      end
    end
  end
end
