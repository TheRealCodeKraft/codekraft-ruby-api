module Codekraft
  module Api
    module Service
      class Base
        def initialize(model)
          @model = model
        end

        def fetchAll params
           @model.all
        end

        def fetchOne params
          @model.find(params[:id])
        end

        def create params
          @model.create!(params)
        end

        def update params
          @model.update!(params)
        end

        def delete params
          @model.destroy(params[:id])
        end
      end
    end
  end
end
