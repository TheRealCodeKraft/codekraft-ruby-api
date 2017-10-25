module Codekraft
  module Api
    module Service
      class Base
        def initialize(model)
          @model = model
        end

        def model
          @model
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
          entity = @model.find(params[:id])
          params.delete :id
          entity.update!(params)
        end

        def destroy params
          @model.destroy(params[:id])
        end

        def upload params
          entity = @model.find(params[:id])
          params[params[:fieldname]] = ActionDispatch::Http::UploadedFile.new(params[params[:fieldname]])
          params.delete :fieldname
          entity.update!(params)
          entity
        end
      end
    end
  end
end
