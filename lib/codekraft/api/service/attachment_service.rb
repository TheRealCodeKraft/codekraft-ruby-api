module Codekraft
	module Api
		module Service
			class AttachmentService < Base

				def initialize
					super(Codekraft::Api::Model::Attachment)
				end

				def create params
					attachment = super(params)
					if attachment.user.nil?
						if attachment.parent.respond_to? :user
							attachment.user = attachment.parent.user
							attachment.save!
						elsif not @current_user.nil?
							attachment.user = @current_user
							attachment.save!
						end
					end
					attachment
				end

			end
		end
	end
end
