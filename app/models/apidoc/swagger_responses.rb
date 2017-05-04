module Apidoc
  module SwaggerResponses
    module AuthenticationError
      include Swagger::Blocks

      def self.extended(base)
        base.response 401 do
          key :description, 'error message'
        end
      end
    end
  end
end
