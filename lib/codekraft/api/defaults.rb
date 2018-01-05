module Codekraft
  module Api
    module Defaults

      extend ActiveSupport::Concern

      included do
        #prefix ""
        version "v1", using: :path
        default_format :json
        format :json
        formatter :json, 
             Grape::Formatter::ActiveModelSerializers

        helpers do

          def logger
            Rails.logger
          end

          def current_token
            doorkeeper_access_token
          end

          def current_user
            resource_owner
          end

          def resource_owner
            @user ||= ((doorkeeper_token.nil? || doorkeeper_token[:resource_owner_id].nil?) ? nil : Codekraft::Api::Model::User.find(doorkeeper_token[:resource_owner_id]))
          end

          def current_scopes
            current_token.scopes
          end

          def authorize_admin!
            if not is_admin?
              status 401
              error!({error: {message: "Administrator specific endpoint, unauthorized !", status: 401}}, 401)
            end
          end

          def authorize_superadmin!
            if not is_superadmin?
              status 401
              error!({error: {message: "Super-Administrator specific endpoint, unauthorized !", status: 401}}, 401)
            end
          end

          def is_admin?
            current_user.role == "admin" || current_user.role == "superadmin"
          end

          def is_superadmin?
            current_user.role == "superadmin"
          end

        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          error!({error: true, message: e.message, status: 404}, 404)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          error!({error: true, message: e.message, status: 422}, 422)
        end

        rescue_from ActiveModel::UnknownAttributeError do |e|
          error!({error: true, message: e.message, status: 400}, 400)
        end

      end

    end
  end
end
