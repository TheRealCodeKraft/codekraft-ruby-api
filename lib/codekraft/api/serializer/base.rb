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

        def is_logged?
          not current_user.nil?
        end

        def is_admin?
          if not current_user.nil?
            current_user.is_admin?
          else
            false
          end
        end

				def is_role? role
          if not current_user.nil?
						current_user.role == role
					else
						false
					end
				end

        def current_route
          if not instance_options.nil? and instance_options.has_key? :current_route
            instance_options[:current_route]
          elsif not scope.nil?
            scope.current_route
          else
            nil
          end
        end

        def query_string
          if not instance_options.nil? and instance_options.has_key? :query_string
            instance_options[:query_string]
          elsif not scope.nil?
            scope.query_string
          else
            nil
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
