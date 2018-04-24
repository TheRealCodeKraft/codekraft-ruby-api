module Codekraft
  module Api
    class Configuration
      attr_accessor :prod_url, :default_mail_from, :endpoints, :resources

      def endpoints
        {
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
          },
          upload: {
            method: "put",
            route: "/:id/:fieldname",
            service: "upload",
            auth: [:doorkeeper_authorize!]
          },
          deleteFile: {
            method: "delete",
            route: "/:id/:fieldname",
            service: "deleteFile",
            auth: [:doorkeeper_authorize!]
          }
        }.merge!(@endpoints ||= {})
      end

      def resources
        {
          user: {
            service: Codekraft::Api::Service::User.new,
            endpoints: {
              create: {
                auth: nil
              },
              me: {
                method: "get",
                route: "/me",
                service: {
                  function: "fetchOne",
                  params: {id: "current_user ? current_user.id : nil"},
                  auth: [:doorkeeper_authorize!]
                }
              },
              forgot_password: {
                method: "get",
                route: "/forgot-password",
                service: {
                  function: "forgotPassword"
                }
              },
              check_stamp: {
                method: "get",
                route: "/check-stamp",
                service: "checkStamp"
              },
              update_password: {
                method: "put",
                route: "/update-password/:id",
                service: "updatePassword"
              }
            },
            serializer: {
              attributes: [:id, :firstname, :lastname, :email, :role, :no_password]
            }
          },
          page: {
            service: Codekraft::Api::Service::Page.new,
            endpoints: {
              fetchAll: {
                auth: nil
              },
            },
            serializer: {
              attributes: [:id, :slug, :title, :body, :group]
            }
          },
					post: {
						endpoints: {
							fetchAll: {
								auth: [:doorkeeper_authorize!]
							},
						}
					},
					notification: {
						service: Codekraft::Api::Service::NotificationService.new,
						endpoints: {
							fetchAll: {
								auth: [:doorkeeper_authorize!]
							}
						}
					},
					subscription: {
						service: Codekraft::Api::Service::SubscriptionService.new,
						endpoints: {
							fetchAll: {
								auth: [:doorkeeper_authorize!]
							},
							toggle: {
								method: "put",
								route: "/toggle/:notification_desc_id/:type",
								service: { function: "toggle" },
								auth: [:doorkeeper_authorize!]
							}
						}
					},
        }.merge!(@resources ||= {})
      end
      
    end

    class << self
      attr_writer :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield configuration
    end
  end
end
