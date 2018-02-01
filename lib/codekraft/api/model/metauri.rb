module Codekraft
  module Api
    module Model
      class Metauri < Base

        has_and_belongs_to_many :posts

      end
    end
  end
end
