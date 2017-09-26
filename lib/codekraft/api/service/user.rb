module Codekraft
  module Api
    module Service
      class User < Base

        def create params
          params[:salt] = ::BCrypt::Engine.generate_salt
          params[:encrypted_password] = encrypt_password(params[:password], params[:salt])
          params.delete :password
          params.delete :password_confirm
          params[:email] = params[:email].downcase
          super(params)
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

        def encrypt_password password, salt
          ::BCrypt::Engine.hash_secret(password, salt)
        end

      end
    end
  end
end
