module Codekraft
  module Api
    module Service

      class SubscriptionService < Base

        def initialize
          super(Codekraft::Api::Model::Subscription)
        end

        def fetchAll params
          params[:user] = @current_user
          subscriptions = super(params).to_a
          if subscriptions.size > 0
            notifications_descs = Codekraft::Api::Model::NotificationDesc.where("id not in (?)", subscriptions.map{ |sub| sub.notification_desc_id })
          else
            notifications_descs = Codekraft::Api::Model::NotificationDesc.all
          end

          notifications_descs.each do |desc|
            subscriptions.push Codekraft::Api::Model::Subscription.new({user: @current_user, notification_desc_id: desc.id, email_push: true, mobile_push: true})
	  end
          {
            subscriptions: subscriptions.map { |sub| Codekraft::Api::Serializer::SubscriptionSerializer.new(sub, {root: false})  }
          }
        end

        def toggle params
          subscription = @model.find_by(user: @current_user, notification_desc_id: params[:notification_desc_id])
          if subscription.nil?
            subscription = Codekraft::Api::Model::Subscription.create!({user: @current_user, notification_desc_id: params[:notification_desc_id], email_push: true, mobile_push: true})
          end
          subscription[params[:type]] = !subscription[params[:type]]
          subscription.save!
	  subscription
        end

      end
    end
  end
end
