module Codekraft
  module Api
    module Service
      class FilterService < Base

        def initialize
          super(Codekraft::Api::Model::Filter)
        end

				def fetchAll params
					if not params.has_key? :all
						params[:user] = @current_user
					end
					super(params)
				end

				def create params
					params[:content] = JSON.parse(params[:content])
					params[:user] = @current_user
					super(params)
				end

				def update params
					params[:content] = JSON.parse(params[:content])
					super(params)
				end

			end
		end
	end
end
