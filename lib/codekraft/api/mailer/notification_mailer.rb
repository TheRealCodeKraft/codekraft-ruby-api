module Codekraft
	module Api
		module Mailer
			class NotificationMailer < Base

				def push notification
					@user = notification.recipient
          mail(	to: notification.recipient.email, 
								from: Codekraft::Api.configuration.default_mail_from, 
								subject: notification.description
					)
				end

			end
		end
	end
end
