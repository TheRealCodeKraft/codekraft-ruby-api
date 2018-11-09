module Codekraft
  module Api
    module Mailer
      class Base < ActionMailer::Base
        default from: Codekraft::Api.configuration.default_mail_from
        layout 'mailer'

        def base_url
          Rails.env.production? ? Codekraft::Api.configuration.prod_url : ENV['FRONT_URL'] || "http://localhost:3002"
        end
      end
    end
  end
end
