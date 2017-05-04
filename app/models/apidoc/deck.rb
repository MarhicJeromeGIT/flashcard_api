module Apidoc
  class Deck
    include Swagger::Blocks

    swagger_schema :Deck do
      key :required, [:id]
      property :id do
        key :type, :integer
        key :description, 'card id'
      end
    end
  end
end
