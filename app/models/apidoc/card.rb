module Apidoc
  class Card
    include Swagger::Blocks

    swagger_schema :Card do
      key :required, [:question, :answer]
      property :question do
        key :type, :string
      end
      property :answer do
        key :type, :string
      end
    end
  end
end
