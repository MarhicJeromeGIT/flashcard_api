module Apidoc
  class StatisticsDocController < ActionController::Base
    include Swagger::Blocks

    swagger_path '/statistics/forecast' do
      operation :get do
        extend SwaggerResponses::AuthenticationError
        key :description, 'Get the forecast statistics'
        key :operationId, 'forecast'
        key :tags, [
          'statistics'
        ]
        parameter :token
        response 200 do
          key :description, 'A hash where keys are the due month ' \
                            '(0: overdue, 1: due in less than one month from now, etc)' \
                            'and the values the number of cards due for that month'
        end
      end
    end

    swagger_path '/statistics/answer_buttons' do
      operation :get do
        extend SwaggerResponses::AuthenticationError
        key :description, 'Get the answer buttons statistics'
        key :operationId, 'answer_buttons'
        key :tags, [
          'statistics'
        ]
        parameter :token
        response 200 do
          key :description, 'A hash where keys are the rating given ' \
                            '(from 0 to 5)' \
                            'and the values the number of assessments with that rating'
        end
      end
    end

    swagger_path '/statistics/cumulative_time' do
      operation :get do
        extend SwaggerResponses::AuthenticationError
        key :description, 'Get the cumulative time statistics'
        key :operationId, 'cumulative_time'
        key :tags, [
          'statistics'
        ]
        parameter :token
        response 200 do
          key :description, 'A hash where keys are the cards id ' \
                            'and the values the cumulative time spent ' \
                            'studying that specific card.'
        end
      end
    end
  end
end
