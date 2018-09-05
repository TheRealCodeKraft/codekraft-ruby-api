module Codekraft
  module Api
    module Service
      class Post < Base

        def initialize model
          super(model)
        end

        def create params
          if params.has_key? :attachments
            attachments=[]
            params[:attachments].each do |file|
              attachments << Codekraft::Api::Model::Attachment.create!({attachment: ActionDispatch::Http::UploadedFile.new(file), user: @current_user})
            end
            params[:attachments] = attachments
          end
          user = @current_user.nil? ? params[:user] : @current_user
          params[:user] = user
          params[:author_name] = user.firstname + " " + user.lastname
          params[:published_at] = DateTime.now
          super(params)
        end

        def update params
          post = @model.find(params[:id])
          if params.has_key? :attachments
            attachments = []
            if not params[:attachments].empty?
              params[:attachments].each do |attachment|
                a = JSON.parse("{}")
                if attachment.is_a? String
                  a = JSON.parse(attachment)
                end
                if a.has_key? "id"
                  attachment = Codekraft::Api::Model::Attachment.find(a["id"])
                else
puts attachment.inspect
                  attachment = Codekraft::Api::Model::Attachment.create!({attachment: ActionDispatch::Http::UploadedFile.new(attachment), user: @current_user})
                end
                attachments << attachment
              end
            end
            params[:attachments] = attachments  
          end
          super(params)
        end

        def fetchAll params
          #payload = nil
					if params.has_key? :all
						params.delete :all
					end
          where = self.model
          params.each do |key, param|
            if self.model.content_attributes.with_indifferent_access.has_key? key
              #payload = {} unless not payload.nil?
              #payload[key] = param
              where = where.where("payload->>'#{key}' = ?", param)
              params.delete key
            end
          end

          #if not payload.nil?
#puts payload
          #  where = where.where('payload @> ?', payload.to_s)
          #end
          where.where(params)
        end

      end
    end
  end
end
