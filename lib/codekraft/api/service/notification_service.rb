module Codekraft
  module Api
    module Service
      class NotificationService < Base
        def initialize
          super(Codekraft::Api::Model::Notification)
        end

        def fetchAll params
          params[:recipient] = @current_user
          super(params)
        end

        def create params
          notification = super(params)
          Notifications::NewNotifJob.perform_later(notification)
          notification
        end

      end
    end
  end
end
