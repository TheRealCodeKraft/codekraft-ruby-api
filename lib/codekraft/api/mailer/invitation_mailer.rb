module Codekraft
  module Api
    module Mailer
      class InvitationMailer < Base
        def invite user, title
          stamp = SecureRandom.uuid
          user.stamp_salt = BCrypt::Engine.generate_salt
          user.stamp = Codekraft::Api::Service::User.new.encrypt_password(stamp, user.stamp_salt)
          user.stamp_expiration = 2.days.from_now
          user.save!

          @user = user
          @url = base_url + "?email=#{user.email}&stamp=#{stamp}"
					@title = ENV["INVITATION_MAIL_HEADER_TITLE"]

          mail(to: user.email, from:Codekraft::Api.configuration.default_mail_from, subject: title.nil? ? "Vous êtes invité à rejoindre la plateforme" : title)

        end
      end
    end
  end
end
