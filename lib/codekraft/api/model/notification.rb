module Codekraft
  module Api
    module Model
      class Notification < Base

        belongs_to :item, polymorphic: true
        belongs_to :recipient, polymorphic: true
        belongs_to :notification_desc

      end
    end
  end
end
