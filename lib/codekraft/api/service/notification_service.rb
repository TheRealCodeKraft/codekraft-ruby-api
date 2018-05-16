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
					if not params[:item].nil? and params[:item].is_a? Object and params[:item].respond_to? :post
						params[:parent_post] = params[:item].post
					end
          notification = super(params)
          Notifications::NewNotifJob.perform_later(notification)
          notification
        end

      end
    end
  end
end
