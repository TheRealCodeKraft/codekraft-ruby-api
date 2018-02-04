module Codekraft
  module Api
    module Utils
      class Logger
        def self.log message
          puts " CODEKRAFT|> ".green + message
        end

        def self.debug message
          puts " DEBUGGER|>>> ".yellow + message
        end
      end
    end
  end
end
