module Apidoc
  class StudySchedule
    include Swagger::Blocks
    
    swagger_schema :StudySchedule do
      key :required, [:deck, :server_time]
      property :deck do
        key :type, :array
        items do
          key :type, :integer
        end
      end
      property :server_time do
        key :type, :integer
        key :description, 'server current time in seconds'
      end
    end
  end
end
