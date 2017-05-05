require 'test_helper'

class AssessmentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    FactoryGirl.create_list(:card, 10)
    @user = create(:user)
  end

  test 'get a 401 if user is not authenticated' do
    post "/api/v1/assessments/#{Card.first.id}",
         params: { rating: 5 }
    assert_response 401

    post "/api/v1/assessments/#{Card.first.id}",
         headers: { token: 'wrongusertoken' },
         params: { rating: 5 }
    assert_response 401
  end

  test 'assess return an error if the card id is wrong' do
    # Wrong card id '12345'
    post '/api/v1/assessments/12345',
         headers: { token: @user.token },
         params: { rating: 5 }
    assert_response 422
  end

  test 'post an assessment' do
    post "/api/v1/assessments/#{Card.first.id}",
         headers: { token: @user.token },
         params: { rating: 5 }
    assert_response :success
  end
end
