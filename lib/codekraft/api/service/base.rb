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

        def setCurrentUser user
          @current_user = user
        end

        def fetchAll params
					if params.has_key? :all
						params.delete :all
					end
          @model.where(params)
        end

				def order query, sorter
					query.order("#{sorter[:target]} #{sorter[:direction]}")
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
          entity
        end

        def destroy params
          @model.destroy(params[:id])
        end

        def upload params
          entity = @model.find(params[:id])

					Rails.logger.info params[:fieldname]
					Rails.logger.info @model.reflect_on_all_associations
					paramClassName = ""
					if @model.reflect_on_all_associations.select { |assoc| assoc.name == params[:fieldname].to_sym }.size > 0
						paramClassName = @model.reflect_on_all_associations.select { |assoc| assoc.name == params[:fieldname].to_sym }[0].class_name
					end

					if paramClassName == "Codekraft::Api::Model::Attachment"
						params[params[:fieldname]] = Codekraft::Api::Model::Attachment.create!({attachment: ActionDispatch::Http::UploadedFile.new(params[params[:fieldname]])})
					else
						params[params[:fieldname]] = ActionDispatch::Http::UploadedFile.new(params[params[:fieldname]])
					end

					params.delete :fieldname
          entity.update!(params)
          entity
        end

        def deleteFile params
          entity = @model.find(params[:id])
					Rails.logger.info entity.public_send(params[:fieldname])
          entity.public_send(params[:fieldname]).destroy
          #entity.sheet.destroy
          entity.save!
          entity
        end

        def is_admin?
					if @current_user and @current_user.role == "admin"
						return true
					end

					return false
        end

      end
    end
  end
end
