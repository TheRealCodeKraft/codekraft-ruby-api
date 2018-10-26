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

						Codekraft::Api::Utils::Logger.log "... MOUNT #{res[:plural].to_s}".light_blue

						# Resource has no correct service set
						if not (res.has_key?(:service) and res[:service].is_a?(Object))
							# Searching for service in custom source code
							res[:service] = "#{res[:name].camelize}Service"
							# Service does not exists in custom source code
							if not (res[:service].safe_constantize and res[:service].safe_constantize.is_a?(Class))
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
									else
										res[:model] = res[:model].safe_constantize
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
							if res[:service].nil?
								res[:service] = Codekraft::Api::Service::Base.new(Codekraft::Api::Model::Base)
							end
						end

						begin
							ActiveRecord::Base.establish_connection # Establishes connection
							ActiveRecord::Base.connection # Calls connection object

							if not ActiveRecord::Base.connection.data_source_exists? res[:plural]
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
									Codekraft::Api::Utils::Logger.log "	> No method found for endpoint #{res[:name]} with key ".red + "#{key.to_s}".green + "." + " Ignoring ..."
									next
								end
								Codekraft::Api::Utils::Logger.log "| ".green + "#{endpoint[:method].upcase}".yellow + "\t/#{res[:plural]}".light_blue + "#{endpoint[:route]}"
								desc endpoint.has_key?(:description) ? endpoint[:description] : (endpoint[:method].upcase + " " + res[:name])
								self.send(endpoint[:method], *[endpoint[:route], {root: res[:plural]}]) do
									if endpoint[:auth]
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

									serializerKlassName = "#{res[:name].camelize}Serializer"
									if not res[:model].nil? and not (serializerKlassName.safe_constantize and serializerKlassName.safe_constantize.is_a?(Class))
										serializerKlassName = res[:model].name
										if serializerKlassName.include?("::Model")
											serializerKlassName["::Model"] = "::Serializer"
										end
										serializerKlassName = "#{serializerKlassName}Serializer"
									end

									if not (serializerKlassName.safe_constantize and serializerKlassName.safe_constantize.is_a?(Class))
										serializerKlassName = "#{res[:name].camelize}Serializer"
										serializer_attributes = (res.has_key? :serializer and res[:serializer].has_key? :attributes) ? res[:serializer][:attributes] : []
										if serializer_attributes.size == 0 and not res[:model].nil?
											res[:model].new.attributes.each do |attr_name, attr_value|
												serializer_attributes.push attr_name
											end
										end
										serializerKlass = Class.new(Codekraft::Api::Serializer::Base) do
											attributes *serializer_attributes
										end
										Object.const_set serializerKlassName, serializerKlass
										Codekraft::Api::Utils::Logger.log "MISSING |>".light_red + " Serializer " + "#{serializerKlassName}".light_green + " <| BUILT!".light_red
									end

									cu = current_user
									serializerKlass.singleton_class.class_eval do
										define_method(:current_user) do
											cu
										end
									end

									if res[:service].respond_to?(:setCurrentUser)
										res[:service].setCurrentUser current_user
									end

									page=nil
									per_page=nil
									if not endpoint.has_key? :transfer_pagination or endpoint[:transfer_pagination].nil?
										if params.has_key? :page
											page = params[:page].to_i
											params.delete :page
										end
										if params.has_key? :per_page
											per_page = params[:per_page].to_i
											params.delete :per_page
										end
									end

									sorter = nil
									if params.has_key? :sort
										sorter = params[:sort].split('|')
										sorter = { target: sorter[0], direction: sorter[1] }
										params.delete :sort
									end

									result = res[:service].send(callService, params)

									if not sorter.nil?
										result = result.order("#{sorter[:target]} #{sorter[:direction] == "up" ? "ASC" : "DESC"}")
									end

									if not result.nil? and not result.is_a? Searchkick::Results and not (result.is_a? Hash and result.has_key? :search_kick and result[:search_kick]) and not page.nil? and not per_page.nil?
										params[:page] = page
										params[:per_page] = per_page
										#result = result.limit(per_page).offset(per_page * (page - 1))
										Codekraft::Api::Utils::Logger.log "PAGINATION >> ".light_red + " Page :	" + "#{page}".light_green + " | Per page : " + "#{per_page}".light_red
										result = paginate(::Kaminari::paginate_array(result).page(page).per(per_page))
									end

									result
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
