require 'test_helper'

class StatisticsIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    Rails.cache.clear
    clear_redis
    FactoryGirl.create_list(:card, 30)
    @user = create(:user)
  end

  test 'the forecast statistics API is correct' do
    # The user hasn't made any assessment yet so
    # All the cards are overdue
    get '/api/v1/statistics/forecast', headers: { token: @user.token }
    assert_response :success
    forecast = JSON.parse response.body
    assert_equal({ '0' => Card.count }, forecast)

    # Assess two cards and check that we have less cards overdue
    post "/api/v1/assessments/#{Card.first.id}",
         headers: { token: @user.token },
         params: { rating: 5 }
    post "/api/v1/assessments/#{Card.second.id}",
         headers: { token: @user.token },
         params: { rating: 5 }
    get '/api/v1/statistics/forecast', headers: { token: @user.token }
    assert_response :success
    forecast = JSON.parse response.body
    assert_equal({ '0' => (Card.count - 2) }, forecast.slice('0'))
  end

  test 'the answer_buttons statistics API is correct' do
    # The user hasn't made any answer yet
    get '/api/v1/statistics/answer_buttons', headers: { token: @user.token }
    assert_response :success
    answer_buttons = JSON.parse response.body
    assert_equal({}, answer_buttons)

    post "/api/v1/assessments/#{Card.second.id}",
         headers: { token: @user.token },
         params: { rating: 5 }
    post "/api/v1/assessments/#{Card.second.id}",
         headers: { token: @user.token },
         params: { rating: 5 }
    post "/api/v1/assessments/#{Card.third.id}",
         headers: { token: @user.token },
         params: { rating: 4 }
    get '/api/v1/statistics/answer_buttons', headers: { token: @user.token }
    assert_response :success
    answer_buttons = JSON.parse response.body
    assert_equal({ '5' => 2, '4' => 1 }, answer_buttons)
  end

  test 'the cumulative_time statistics API is correct' do
    # The user hasn't made any answer yet,
    # the time for each card should be 0
    get '/api/v1/statistics/cumulative_time', headers: { token: @user.token }
    assert_response :success
    cumulative_time = JSON.parse response.body
    assert_equal(Card.count, cumulative_time.keys.count)
    assert(cumulative_time.values.all?(&:zero?))

    post "/api/v1/assessments/#{Card.second.id}",
         headers: { token: @user.token },
         params: { rating: 5, elapsed_time: 1000 }
    post "/api/v1/assessments/#{Card.second.id}",
         headers: { token: @user.token },
         params: { rating: 5, elapsed_time: 2000 }
    post "/api/v1/assessments/#{Card.third.id}",
         headers: { token: @user.token },
         params: { rating: 4, elapsed_time: 1234 }
    get '/api/v1/statistics/cumulative_time', headers: { token: @user.token }
    assert_response :success
    cumulative_time = JSON.parse response.body
    assert_equal(3000, cumulative_time[Card.second.id.to_s])
    assert_equal(1234, cumulative_time[Card.third.id.to_s])
  end
end
