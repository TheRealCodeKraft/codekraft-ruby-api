module Codekraft
  module Api
    module Service
      class User < Base

        def create params
          params[:salt] = BCrypt::Engine.generate_salt
          params[:encrypted_password] = encrypt_password(params[:password], params[:salt])
          params.delete :password
          params.delete :password_confirm
          params[:email] = params[:email].downcase
          super(params)
        end

      end
    end
  end
end
