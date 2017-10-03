module Codekraft
  module Api
    module Model
      class Page < Post
        content_attr :body, :text

        validates :body, presence: true
      end
    end
  end
end
