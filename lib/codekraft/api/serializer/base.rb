module Codekraft
  module Api
    module Serializer
      class Base < ActiveModel::Serializer

        def current_user
          if not instance_options.nil? and instance_options.has_key? :current_user
            instance_options[:current_user]
          elsif not scope.nil?
            scope.current_user
          else
            nil
          end
        end

        def is_admin?
          if not current_user.nil?
            current_user.is_admin?
          else
            true
          end
        end

				def attachment_url attachment
					if Rails.env.production?
						if attachment.url.include?("s3.amazonaws")
							"https:#{attachment.url.sub("s3.amazonaws", "s3.eu-west-2.amazonaws")}"
						else
							"https://forgemeup-api.herokuapp.com#{attachment.url}"
						end
					else
						"http://localhost:3000#{attachment.url}"
					end
				end

      end
    end
  end
end
