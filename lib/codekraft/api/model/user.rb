module Codekraft
  module Api
    module Model
      class User < Base

        validates_format_of :firstname, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/, if: '!no_password'
        validates_format_of :lastname, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/, if: '!no_password'

        validates :email, uniqueness: true
        validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

        validates :salt, presence: true, if: '!no_password'
        validates :encrypted_password, presence: true, if: '!no_password'

        def is_admin?
          role == "admin"
        end
      end
    end
  end
end
