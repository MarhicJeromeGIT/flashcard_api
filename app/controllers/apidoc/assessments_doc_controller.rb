module Apidoc
  class AssessmentsDocController < ActionController::Base
    include Swagger::Blocks

    swagger_path '/assessments/{card_id}' do
      operation :post do
        extend SwaggerResponses::AuthenticationError
        extend SwaggerResponses::ParameterError
        key :description, 'Post the user assessment for a given card id'
        key :operationId, 'assessments'
        key :tags, [
          'assessments'
        ]
        parameter :token
        parameter do
          key :name, :card_id
          key :in, :path
          key :description, 'card id'
          key :required, true
          key :type, :integer
          key :format, :int64
        end
        parameter do
          key :name, :assessment
          key :in, :body
          key :description, 'the user assessment'
          key :required, true
          schema do
            key :'$ref', :AssessmentInput
          end
        end
        response 200 do
          key :description, 'empty'
        end
      end
    end
  end
end
