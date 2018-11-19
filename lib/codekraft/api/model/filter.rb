module Codekraft
  module Api
    module Model
      class Filter < Base

				belongs_to :user, class_name: "Codekraft::Api::Model::User"

			end
		end
	end
end
