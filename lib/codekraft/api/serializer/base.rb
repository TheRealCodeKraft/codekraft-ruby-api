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

      end
    end
  end
end
