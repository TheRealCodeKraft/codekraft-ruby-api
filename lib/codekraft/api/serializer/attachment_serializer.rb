module Codekraft
  module Api
    module Serializer
      class AttachmentSerializer < Base

        attributes :id, :file_url, :original_filename, :original_file_url, :created_at, :updated_at

        def file_url
          if Rails.env.production?
            if object.attachment.url.include?("s3.amazonaws")
              "https:#{object.attachment.url(:medium).sub("s3.amazonaws", "s3.eu-west-2.amazonaws")}"
            else
              "https://forgemeup-api.herokuapp.com#{object.attachment.url(:medium)}"
            end
          else
            "http://localhost:3000#{object.attachment.url(:medium)}"
          end
        end

				def original_filename
					object.attachment.original_filename
				end

				def original_file_url
					if Rails.env.production?
            if object.attachment.url.include?("s3.amazonaws")
              "https:#{object.attachment.url(:original).sub("s3.amazonaws", "s3.eu-west-2.amazonaws")}"
            else
              "https://forgemeup-api.herokuapp.com#{object.attachment.url(:original)}"
            end
          else
            "http://localhost:3000#{object.attachment.url(:original)}"
          end
				end

      end
    end
  end
end
