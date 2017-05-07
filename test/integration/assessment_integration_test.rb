require 'test_helper'

class AssessmentIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    Rails.cache.clear
    clear_redis
    FactoryGirl.create_list(:card, 30)
    @user = create(:user)
  end

  # Test that the API is 'complete'
  test 'the user assessment modify the given card next time up' do
    get '/api/v1/study_schedule',
        headers: { token: @user.token }
    data = JSON.parse response.body
    deck = data['deck']
    
    card_id = deck[0][0]
    card_time = deck[0][1]
    # Make sure that the card is overdue
    assert(card_time <= Time.now.to_i)

    # Rate the card several times and make sure the card time increases accordingly
    post "/api/v1/assessments/#{card_id}",
         headers: { token: @user.token },
         params: { rating: 5, elapsed_time: 1000 }
    
    get '/api/v1/study_schedule',
        headers: { token: @user.token }
    data = JSON.parse response.body
    deck = data['deck']
    _card_id_2, card_time_2 = deck.find { |id,time| id == card_id }
    
    # The card should be due in ~ 1.day, takes one minute error margin
    expected_time = 1.day.from_now.to_i
    assert(card_time_2 > expected_time - 60)
    assert(card_time_2 < expected_time + 60)

    # One more time...
    post "/api/v1/assessments/#{card_id}",
         headers: { token: @user.token },
         params: { rating: 5, elapsed_time: 1000 }

    get '/api/v1/study_schedule',
        headers: { token: @user.token }
    data = JSON.parse response.body
    deck = data['deck']
    _card_id_3, card_time_3 = deck.find { |id, _time| id == card_id }

    # The card should be due in ~ 6.days, takes one minute error margin
    expected_time = 6.days.from_now.to_i
    assert_in_delta(expected_time, card_time_3, 60)
  end
end
