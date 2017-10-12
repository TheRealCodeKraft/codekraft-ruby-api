require 'doorkeeper/grape/helpers' 
require "grape-swagger"
require "grape-swagger-representable"

module Codekraft
  module Api
    module Endpoint

      extend ActiveSupport::Concern

      included do

        if not Codekraft::Api.configuration.nil? and not Codekraft::Api.configuration.resources.nil?

          Codekraft::Api::Utils::Logger.log "Mouting API Endpoints".yellow
          Codekraft::Api::Utils::Logger.log "#{Codekraft::Api.configuration.resources.size} endpoints found"

          Codekraft::Api.configuration.resources.each do |key, res|

            res[:name] = key.to_s
            res[:plural] = res[:name]+"s" unless (res.has_key? :plural and not res[:plural].nil?)

            puts ""
            Codekraft::Api::Utils::Logger.log "... MOUNT #{res[:plural].to_s}".light_blue

            # Resource has no correct service set
            if not (res.has_key?(:service) and res[:service].is_a?(Object))
              # Searching for service in custom source code
              res[:service] = "#{res[:name].camelize}Service"
puts res[:service]
              # Service does not exists in custom source code
              if not (res[:service].safe_constantize and res[:service].safe_constantize.is_a?(Class))
puts "DOES NOT EXISTS"
                #res[:model] = res[:name].camelize unless (res.has_key? :model and not res[:model].nil?)

                # Model is not set on resource
                if not res.has_key? :model
                  res[:model] = res[:name].camelize
                end

                # Model is not a class
                if not res[:model].is_a?(Class)

                  # Model does not exists in custom source code
                  if not (res[:model].safe_constantize and res[:model].safe_constantize.is_a?(Class))
                    Codekraft::Api::Utils::Logger.log "MISSING |>".light_red + " Model " + "#{res[:model]}".light_green + " <| BUILT!".light_red
                    modelKlass = Class.new(Codekraft::Api::Model::Base) do
                    end
                    Object.const_set res[:model], modelKlass
                    res[:model] = res[:model].constantize
                  end

                end
                res[:service] = Codekraft::Api::Service::Base.new(res[:model])

              # Service exists in custom source code
              else
                res[:service] = res[:service].constantize.new
              end
            end

            if res[:service].respond_to?(:model) and res[:service].model.is_a?(Class)
              res[:model] = res[:service].model
            else
              Codekraft::Api::Utils::Logger.log "ERROR |>".light_red + " Service for " + "#{res[:name]}".light_green + " does not own a correct Model".light_red + " <| " + "You may experience some trouble in execution".light_yellow
              res[:service] = Codekraft::Api::Service::Base.new(Codekraft::Api::Model::Base)
            end

            begin
              ActiveRecord::Base.establish_connection # Establishes connection
              ActiveRecord::Base.connection # Calls connection object

              if not ActiveRecord::Base.connection.table_exists? res[:plural]
                Codekraft::Api::Utils::Logger.log "MiSSING |>".light_red + " Table " + "#{res[:plural]}".light_green + " <| " + "You may create the table with db migration".light_yellow
              end
            rescue
            end

            if res.has_key? :endpoints and not res[:endpoints].nil?
              Codekraft::Api.configuration.endpoints.each do |beKey, be|
                if res[:endpoints].has_key? beKey
                  res[:endpoints][beKey] = be.merge res[:endpoints][beKey]
                else
                  res[:endpoints][beKey] = be
                end
              end
            else
              res[:endpoints] = Codekraft::Api.configuration.endpoints
            end

            resource res[:plural] do
              res[:endpoints].each do |key, endpoint|
                if not endpoint.has_key? :method
                  Codekraft::Api::Utils::Logger.log "  > No method found for endpoint #{res[:name]} with key ".red + "#{key.to_s}".green + "." + " Ignoring ..."
                  next
                end
                Codekraft::Api::Utils::Logger.log "| ".green + "#{endpoint[:method].upcase}".yellow + "\t/#{res[:plural]}".light_blue + "#{endpoint[:route]}"
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

                  serializerKlassName = "#{res[:name].capitalize}Serializer"
                  if not (serializerKlassName.safe_constantize and serializerKlassName.safe_constantize.is_a?(Class))
                    Codekraft::Api::Utils::Logger.log "MISSING |>".light_red + " Serializer " + "#{serializerKlassName}".light_green + " <| BUILT!".light_red
                    serializer_attributes = (res.has_key? :serializer and res[:serializer].has_key? :attributes) ? res[:serializer][:attributes] : {}
                    serializerKlass = Class.new(Codekraft::Api::Serializer::Base) do
                      attributes *serializer_attributes
                    end
                    Object.const_set serializerKlassName, serializerKlass
                  end

                  res[:service].send(callService, params)
                end
              end
            end
          end
        end

        add_swagger_documentation api_version: "v1"
      end
    end
  end
end
