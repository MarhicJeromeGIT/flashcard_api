module Apidoc
  class AssessmentInput
    include Swagger::Blocks

    swagger_schema :AssessmentInput do
      key :required, [:rating, :elapsed_time]
      property :rating do
        key :type, :integer
        key :description, 'card rating in [0;5]'
      end
      property :elapsed_time do
        key :type, :integer
        key :description, 'time spent assessing the card, in ms'
      end
    end
  end
end
