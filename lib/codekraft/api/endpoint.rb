require 'doorkeeper/grape/helpers' 

module Codekraft
  module Api
    class Endpoint < Grape::API

      include Codekraft::Api::Defaults

      helpers Doorkeeper::Grape::Helpers

      before do
      end

      resource :users do

        # Users list
        desc "Get users list"
        params do
        end
        get "", root: :users do
          User.all
        end

        desc "Signup user"
        params do
          requires :firstname, :lastname, :email, :password, :password_confirm, :cgu
          optional :pseudo
        end
        post "", root: :users do
          service.signup params
        end

        desc "Current user"
        get "/me", root: :users do
          doorkeeper_authorize!
          current_user 
        end

        desc "Update an user password"
        params do
          requires :password, :password_confirm
        end
        put "/password/:id", root: :users do
          doorkeeper_authorize!
          if !is_admin?
            if current_user.id.to_s != params[:id]
              error!({error: true, message: "Unauthorized to update the password of another user of yourself", status: 401}, 401)
            end
          end
          service.updatePassword params
        end

        desc "Update an user"
        params do
          optional :firstname, :lastname, :email, :pseudo, :traineeship, :contract, :school_id
          optional :traineeship_start_ts, :traineeship_end_ts
          optional :specialities, type: Array
          optional :areas, type: Array
        end
        put "/:id", root: :users do
          doorkeeper_authorize!
          if !is_admin?
            if current_user.id.to_s != params[:id]
              error!({error: true, message: "Unauthorized to update another user of yourself", status: 401}, 401)
            end
          end
          service.update params
        end

        # Delete User
        desc "Delete a user"
        delete "/:id", root: :users do
          authorize_admin!
          service.delete params[:id]
          {id: params[:id], success: true}
        end

        # Users list
        #desc "Get users list"
        #params do
        #end
        #get "users/:query", root: :users do
        #  filters = { 'criteria[0][key]' => 'firstname', 'criteria[0][value]' => params[:query] }
        #  Moodle::Api.core_user_get_users(filters)
        #end

      end

    end
  end
end
  end
end
