module Codekraft
  module Api
    module Mailer
      class InvitationMailer < Base
        def invite user
          stamp = SecureRandom.uuid
          user.stamp_salt = BCrypt::Engine.generate_salt
          user.stamp = ::UserService.new.encrypt_password(stamp, user.stamp_salt)
          user.stamp_expiration = 2.days.from_now
          user.save!

          @user = user
          @url = base_url + "/?email=#{user.email}&stamp=#{stamp}"

          mail(to: user.email, subject: "Rendez-vous sur notre site")

        end
      end
    end
  end
end
