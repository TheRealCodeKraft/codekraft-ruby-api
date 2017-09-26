module Codekraft
  module Api
    class Service

      def initialize(model)
        self.model = model
      end

      def fetchAll
         self.model.all
      end

      def fetchOne id
        self.model.find(id)
      end

      def create params
        self.model.create!(params)
      end

      def update params
        self.model.update!(params)
      end

      def delete id
        self.model.destroy(id)
      end

    end
  end
end
