module Codekraft
  module Api
    module Service
      class User < Base

        def initialize
          super(Codekraft::Api::Model::User)
        end

        def create params
          if params[:password]
            params[:salt] = ::BCrypt::Engine.generate_salt
            params[:encrypted_password] = encrypt_password(params[:password], params[:salt])
            params[:no_password] = false

            params.delete :password
            params.delete :password_confirm
          else
            params[:no_password] = true
          end
          params[:email] = params[:email].downcase
          user = super(params)
          if user.no_password
            Codekraft::Api::Mailer::InvitationMailer.invite(user).deliver
          end
          user
        end

        def update params
          if params.has_key? :password
            params[:salt] = BCrypt::Engine.generate_salt
            params[:encrypted_password] = encrypt_password(params[:password], params[:salt])
            params.delete :password
            params.delete :password_confirm
          end
          super(params)
        end

        def forgotPassword params
          user = Codekraft::Api::Model::User.find_by({email: params[:email]})
          if not user.nil?
            Codekraft::Api::Mailer::ForgotPasswordMailer.reset_password(user).deliver
          end
          {found: (not user.nil?)}
        end

        def checkStamp params
          user = Codekraft::Api::Model::User.find_by({email: params[:email]})
          result = {found: (not user.nil?), 
                    stamp_ok: Codekraft::Api::Service::User.new.encrypt_password(params[:stamp], user.stamp_salt) == user.stamp,
                    stamp_expiration_ok: user.stamp_expiration < 1.second.from_now}
           if result[:stamp_ok] and result[:stamp_expiration_ok]
             result[:user_id] = user.id
           end
           result
        end

        def updatePassword params
          stamp = checkStamp(params)
          if stamp[:stamp_ok] and stamp[:stamp_expiration_ok]
            params[:stamp] = nil
            params[:stamp_expiration] = nil
            params.delete :email
            update params
          else
            {error: true, message: "Unable to check stamp for password update", stamp_data: stamp}
          end
        end

        def encrypt_password password, salt
          ::BCrypt::Engine.hash_secret(password, salt)
        end

      end
    end
  end
end
