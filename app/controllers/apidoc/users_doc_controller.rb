module Apidoc
  class UsersDocController < ActionController::Base
    include Swagger::Blocks

    swagger_path '/user/reset_deck' do
      operation :post do
        extend SwaggerResponses::AuthenticationError
        key :description, 'Reset an user\'s deck'
        key :operationId, 'reset_deck'
        key :tags, [
          'users'
        ]
        parameter :token
        response 200 do
          key :description, 'no response'
        end
      end
    end
  end
end
