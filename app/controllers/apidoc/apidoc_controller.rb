# http://petstore.swagger.io/?url=http://interview-marhicjeromegit.c9users.io:8080/apidoc.json
# Swagger definitions json generator for the SM2 api.
module Apidoc
  class ApidocController < ActionController::Base
    include Swagger::Blocks

    swagger_root do
      key :swagger, '2.0'
      info do
        key :version, '1.0'
        key :title, 'SuperMemo2 API'
        key :description, 'TODO'
        key :termsOfService, ''
        contact do
          key :name, 'Marhic Jérôme'
        end
        license do
          key :name, 'MIT'
        end
      end
      tag do
        key :name, 'cards'
        key :description, 'Cards operations'
      end
      tag do
        key :name, 'assessments'
        key :description, 'Assessments operations'
      end
      tag do
        key :name, 'statistics'
        key :description, 'Statistics operations'
      end
      parameter :token do
        key :name, :token
        key :in, :header
        key :description, 'Authentification token'
        key :default, 'abcd'
        key :type, :string
      end
      key :host, ENV['BASE_URL']
      key :basePath, '/api/v1/'
      key :consumes, ['application/json']
      key :produces, ['application/json']
    end

    # A list of all classes that have swagger_* declarations.
    SWAGGERED_CLASSES = [
      Apidoc::CardsDocController,
      Apidoc::AssessmentsDocController,
      Apidoc::StatisticsDocController,
      Apidoc::Card,
      Apidoc::Deck,
      Apidoc::AssessmentInput,
      self
    ].freeze

    def index
      respond_to do |format|
        format.json { render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES) }
        format.html
      end
    end
  end
end
