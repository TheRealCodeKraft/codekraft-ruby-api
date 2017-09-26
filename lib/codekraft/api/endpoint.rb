require 'doorkeeper/grape/helpers' 

module Codekraft
  module Api
    class Endpoint < Grape::API

      include Codekraft::Api::Defaults

      helpers Doorkeeper::Grape::Helpers
 
      base_endpoints = {
        fetchAll: {
          method: "get",
          route: "",
          service: "fetchAll",
          auth: [:doorkeeper_authorize!, :authorize_admin!]
        },
        fetchOne: {
          method: "get",
         route: "/:id",
          service: "fetchOne",
          auth: [:doorkeeper_authorize!]
        },
        create: {
          method: "post",
          route: "",
          service: "create",
          auth: [:doorkeeper_authorize!]
        },
        update: {
          method: "put",
          route: "/:id",
          service: "update",
          auth: [:doorkeeper_authorize!]
        },
        delete: {
          method: "delete",
          route: "/:id",
          service: "destroy",
          auth: [:doorkeeper_authorize!]
        }
      }

      resources = {
        user: {
          service: Codekraft::Api::Service::User.new(::User),
          endpoints: {
            create: {
              auth: nil
            },
            me: {
              method: "get",
              route: "/me",
              service: {
                function: "fetchOne",
                params: {id: "current_user.id"},
                auth: [:doorkeeper_authorize!]
              }
            }
          }
        }
      }

      resources.each do |key, res|

        res[:name] = key.to_s
        res[:plural] = res[:name]+"s" unless (res.has_key? :plural and not res[:plural].nil?)
        res[:model] = res[:name].camelize.constantize unless (res.has_key? :model and not res[:model].nil?)
        res[:service] = Codekraft::Api::Service::Base.new(res[:model]) unless (res.has_key? :service and not res[:service].nil?)
        if res.has_key? :endpoints and not res[:endpoints].nil?
          base_endpoints.each do |beKey, be|
            if res[:endpoints].has_key? beKey
              res[:endpoints][beKey] = be.merge res[:endpoints][beKey]
            else
              res[:endpoints][beKey] = be
            end
          end
        else
          res[:endpoints] = base_endpoints
        end

        resource res[:plural] do
          res[:endpoints].each do |key, endpoint|
            puts "> #{endpoint[:method].upcase} #{res[:name]} (#{endpoint[:route]})"
            desc endpoint[:method].upcase + " " + res[:name]
            params do
            end
            self.send(endpoint[:method], *{route: endpoint[:route], root: res[:plural]}) do
              if (endpoint[:auth])
                endpoint[:auth].each do |auth|
                  send(auth)
                end
              end

              callService = endpoint[:service]
              if not callService.is_a?(String)
                callService = callService[:function]
                if endpoint[:service].has_key? :params
                  ext_params = {}
                  endpoint[:service][:params].each do |key, param|
                    ext_params[key] = self.instance_eval(param)
                  end
                  params.merge!(ext_params)
                end
              end
              res[:service].send(callService, params)
            end
          end
        end
      end

      add_swagger_documentation api_version: "v1"

    end
  end
end
