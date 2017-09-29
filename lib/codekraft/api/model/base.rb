module Codekraft
  module Api
    module Model
      class Base < ActiveRecord::Base
        self.abstract_class = true
      end
    end
  end
end
