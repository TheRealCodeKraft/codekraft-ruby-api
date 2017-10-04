module Codekraft
  module Api
    module Model
      class Page < Codekraft::Api::Model::Post
        content_attr :body, :text
        content_attr :group, :text

        validates :body, presence: true
      end
    end
  end
end
