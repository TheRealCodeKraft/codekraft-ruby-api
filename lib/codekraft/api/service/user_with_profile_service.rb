module Codekraft
  module Api
    module Service
      class UserWithProfileService < Codekraft::Api::Service::User

        def initialize entityType, profileType
          super(entityType)
          @profileType = profileType
        end

        def create params

          profile = nil
          if params.has_key? :profile
            profile = @profileType.new(params[:profile])
            params.delete :profile
          else
            profile = @profileType.new()
          end

          user = super(params)

          if not profile.nil?
            profile.user = user
            profile.save
            user.profile = profile
            user.save
          end

          #if user.temp_password
          #  Resque.enqueue(Partnurse::Jobs::Mail, [{username: user.firstname, email: user.email}], "mail.user_pending.title", "mail.user_pending.body", {username: user.firstname, hospital_name: user.profile.hospital.name, token: user.forgot_token, service_name: user.profile.service.nil? ? "Tous les services" : user.profile.service.name, role: user.profile.role == 1 ? "Administrateur" : "Standard"})
          #end

          user

        end

        def update params
          user = fetchOne params

          if params.has_key? :profile
            user.profile.update!(params[:profile])
            params.delete :profile
          end

          #if params.has_key?(:password) and params.has_key?(:confirm_password)
          #  if params.has_key?(:old_password) and encrypt_password(params[:old_password], user.salt) == user.encrypted_password
          #    params[:salt] = BCrypt::Engine.generate_salt
          #    params[:encrypted_password] = encrypt_password(params[:password], params[:salt])
          #  end
          #  params.delete :old_password
          #  params.delete :password
          #  params.delete :confirm_password
          #end

          user.update(params)
          user.save!

          user
        end

      end
    end
  end
end
