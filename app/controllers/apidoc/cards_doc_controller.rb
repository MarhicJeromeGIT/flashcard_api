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
            key :'$ref', :CardId
          end
        end
      end
    end

    swagger_path '/study_schedule' do
      operation :get do
        key :description, 'For each card, return the time (as a timestamp) when the ' \
                          'card has to be studied next. Sorted by increasing time. ' \
                          'Also provide the server current time for reference.'
        key :operationId, 'study_schedule'
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
          key :description, 'schedule response'
          schema do
            key :'$ref', :StudySchedule
          end
        end
      end
    end
  end
end
