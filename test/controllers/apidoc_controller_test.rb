require 'test_helper'

class ApidocControllerTest < ActionDispatch::IntegrationTest
  # TODO: test with the online validator
  test 'The APIDOC is a valid swagger spec' do
    # get 'online.swagger.io/validator/debug?url=http://interview-marhicjeromegit.c9users.io:8080/apidoc.json'
    # assert_response 200
    # spec = JSON.parse response.body

    get '/apidoc'
    assert_response :success
  end
end
