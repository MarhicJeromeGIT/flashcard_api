module Apidoc
  class CardsDocController < ActionController::Base
    include Swagger::Blocks

    swagger_path '/cards' do
      operation :get do
        key :description, 'Return all the card data in the application deck'
        key :operationId, 'cards'
        key :tags, [
          'cards'
        ]
        response 200 do
          key :description, 'deck response'
          schema do
            key :'$ref', :Card
          end
        end
      end
    end

    swagger_path '/vocabulary' do
      operation :get do
        key :description, 'Return the next cards the user has to study'
        key :operationId, 'cards'
        key :tags, [
          'cards'
        ]
        parameter :token
        parameter do
          key :name, :page
          key :in, :query
          key :description, 'page number (pagination)'
          key :required, false
          key :type, :integer
          key :format, :int64
        end
        parameter do
          key :name, :per_page
          key :in, :query
          key :description, 'items per page (pagination)'
          key :required, false
          key :type, :integer
          key :format, :int64
        end
        response 200 do
          key :description, 'deck response'
          schema do
            key :type, :array
            items do
              key :type, :integer
            end
          end
        end
      end
    end
  end
end
