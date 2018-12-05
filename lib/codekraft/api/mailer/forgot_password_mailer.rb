module Codekraft
  module Api
    module Mailer
      class ForgotPasswordMailer < Base
        def reset_password user_id
          user = User.find(user_id)

          stamp = SecureRandom.uuid
          user.stamp_salt = BCrypt::Engine.generate_salt
          user.stamp = Codekraft::Api::Service::User.new.encrypt_password(stamp, user.stamp_salt)
          user.stamp_expiration = 2.days.from_now
          user.save!

          @user = user
          @url = base_url + "/reset-password?email=#{user.email}&key=#{stamp}"

          mail(to: user.email, from:Codekraft::Api.configuration.default_mail_from, subject: "Changer votre mot de passe")

        end
      end
    end
  end
end
