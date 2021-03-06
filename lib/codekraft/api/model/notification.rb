module Codekraft
  module Api
    module Model
      class Notification < Base

        default_scope { order(created_at: :desc) }

        belongs_to :item, polymorphic: true
				belongs_to :parent_post, class_name: "Codekraft::Api::Model::Post"
        belongs_to :sender, polymorphic: true
        belongs_to :recipient, polymorphic: true
        belongs_to :notification_desc

        def description 
          notif = self
          eval '"' + self.notification_desc.template + '"'
        end

        def gdescription 
          notif = self
          eval '"' + self.notification_desc.gtemplate + '"'
        end

      end
    end
  end
end
