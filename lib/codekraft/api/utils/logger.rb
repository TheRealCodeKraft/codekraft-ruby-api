module Codekraft
  module Api
    module Utils
      class Logger
        def self.log message
          puts " CODEKRAFT|> ".green + message
        end
      end
    end
  end
end
