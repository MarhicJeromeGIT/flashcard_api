module Apidoc
  class StudySchedule
    include Swagger::Blocks

    swagger_schema :StudySchedule do
      key :required, [:deck]
      property :deck do
        key :description, 'array of [card_id, timestamp] that represents the '\
                          'next time each card is up for study. '
        key :type, :array
        items do
          key :type, :integer
        end
      end
    end
  end
end
