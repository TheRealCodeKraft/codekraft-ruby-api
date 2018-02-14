module Codekraft
  module Api
    module Model

      class Subscription < Base

        belongs_to :notification_desc, class_name: "Codekraft::Api::Model::NotificationDesc"
        belongs_to :user, class_name: "Codekraft::Api::Model::User"

      end

    end
  end
end
