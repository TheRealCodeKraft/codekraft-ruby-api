module Codekraft
  module Api
    module Model
      class Attachment < Base
        include Paperclip::Glue

        belongs_to :parent, polymorphic: true

        has_attached_file :attachment, :styles => { :large => "1500x1500>", :medium => "500x500>", :thumb => "100x100>" }
        do_not_validate_attachment_file_type :attachment
      end
    end
  end
end
