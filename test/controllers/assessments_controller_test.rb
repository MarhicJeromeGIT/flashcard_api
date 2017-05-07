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
    data = JSON.parse response.body
    assert_match(/card_id/, data['error'])
  end

  test 'assess return an error if there is no elapsed_time info' do
    # Wrong card id '12345'
    post "/api/v1/assessments/#{Card.first.id}",
         headers: { token: @user.token },
         params: { rating: 5 }
    assert_response 422
    data = JSON.parse response.body
    assert_match(/elapsed_time/, data['error'])
  end

  test 'assess return an error if the rating is wrong' do
    # Wrong card id '12345'
    post "/api/v1/assessments/#{Card.first.id}",
         headers: { token: @user.token },
         params: { rating: 10 }
    assert_response 422
    data = JSON.parse response.body
    assert_match(/rating/, data['error'])
  end

  test 'post an assessment' do
    post "/api/v1/assessments/#{Card.first.id}",
         headers: { token: @user.token },
         params: { rating: 5, elapsed_time: 1000 }
    assert_response :success
  end
end
