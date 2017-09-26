module Codekraft
  module Api
    class Service

      def initialize(model)
        @model = model
      end

      def fetchAll
         @model.all
      end

      def fetchOne id
        @model.find(id)
      end

      def create params
        @model.create!(params)
      end

      def update params
        @model.update!(params)
      end

      def delete id
        @model.destroy(id)
      end

    end
  end
end
