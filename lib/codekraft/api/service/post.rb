module Codekraft
  module Api
    module Service
      class Post < Base

        def initialize model
          super(model)
        end

        def create params
          puts params.inspect
          if params.has_key? :attachments
            attachments=[]
            params[:attachments].each do |file|
              puts file.inspect
              attachments << Codekraft::Api::Model::Attachment.create!({attachment: ActionDispatch::Http::UploadedFile.new(file)})
            end
            params[:attachments] = attachments
          end
          params[:user] = @current_user
          params[:author_name] = @current_user.firstname + " " + @current_user.lastname
          params[:published_at] = DateTime.now
          super(params)
        end

        def fetchAll params
          #payload = nil
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
