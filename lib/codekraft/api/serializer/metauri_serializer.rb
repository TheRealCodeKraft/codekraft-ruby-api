module Codekraft
  module Api
    module Serializer
      class MetauriSerializer < Base

        attributes :uri, :title, :description, :image, :metas

        def title
          JSON.parse(object.metas)["best_title"]
        end

        def description
          JSON.parse(object.metas)["best_description"]
        end

        def image
          metas = JSON.parse(object.metas)
          metas["images"].size > 0 ? metas["images"][0] : nil
        end

      end
    end
  end
end
