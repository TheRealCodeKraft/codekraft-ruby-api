module Codekraft
  module Api
    module Mailer
      class UserMailer < Base
        def invite user_id
          @user = User.find(user_id)

          stamp = SecureRandom.uuid
          @user.stamp_salt = BCrypt::Engine.generate_salt
          @user.stamp = Codekraft::Api::Service::User.new.encrypt_password(stamp, @user.stamp_salt)
          @user.stamp_expiration = 2.days.from_now
          @user.save!

          @url = base_url + "/dashboard?email=#{@user.email}&stamp=#{stamp}"
					@title = ENV["INVITATION_MAIL_HEADER_TITLE"]

					title = ENV["INVITATION_MAIL_TITLE"]
          mail(to: @user.email, from:Codekraft::Api.configuration.default_mail_from, subject: title.nil? ? "Vous êtes invité à rejoindre la plateforme" : title)

        end

        def confirm user_id
          @user = User.find(user_id)

					title = ENV["USER_CREATION_MAIL_TITLE"]
          mail(to: @user.email, from: Codekraft::Api.configuration.default_mail_from, subject: title.nil? ? "Bienvenu, vous avez créé votre compte sur la plateforme" : title)

        end
      end
    end
  end
end
