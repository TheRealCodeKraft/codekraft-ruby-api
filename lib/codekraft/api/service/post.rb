module Codekraft
  module Api
    module Service
      class Post < Base

        def initialize model
          super(model)
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
