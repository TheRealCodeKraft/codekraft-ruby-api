module Codekraft
  module Api
    module Model
      class Attachment < Base
        include Paperclip::Glue

        belongs_to :user
        belongs_to :parent, polymorphic: true

        has_attached_file :attachment
        do_not_validate_attachment_file_type :attachment
      end
    end
  end
end
