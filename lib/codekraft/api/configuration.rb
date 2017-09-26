module Codekraft
  module Api
    class Configuration
      attr_accessor :base_endpoints, :resources
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
