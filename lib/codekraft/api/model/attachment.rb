module Codekraft
  module Api
    module Model
      class Attachment < Base
        include Paperclip::Glue

        belongs_to :parent, polymorphic: true

        has_attached_file :attachment, :styles => { :large => "1000x1000>", :medium => "300x300>", :thumb => "100x100>" }
        do_not_validate_attachment_file_type :attachment
      end
    end
  end
end
