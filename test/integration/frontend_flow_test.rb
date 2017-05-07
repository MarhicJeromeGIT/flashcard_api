require 'test_helper'

class FrontendFlowTest < ActionDispatch::IntegrationTest
  def setup
    Rails.cache.clear
    clear_redis
    FactoryGirl.create_list(:card, 30)
    @user = create(:user)
  end

  # Test that the API is 'complete'
  test 'the frontend has every API call it needs for basic usage' do
    # 1. Get the list of all the cards
    # 2. Get the ids of the cards we have to study
    # 3. Study and return user assessment
    get '/api/v1/cards'
    assert_response :success
    cards = JSON.parse response.body
    assert_not_empty(cards)

    per_page = 5
    get '/api/v1/study_schedule',
        params: { page: 1, per_page: per_page },
        headers: { token: @user.token }
    data = JSON.parse response.body
    deck = data['deck']
    assert_equal(per_page, deck.count)
    # Make sure we already have the cards referenced
    deck.each do |card_id, _timestamp|
      assert_not_nil(cards[card_id])
    end

    post "/api/v1/assessments/#{deck[0][0]}",
         headers: { token: @user.token },
         params: { rating: 5, elapsed_time: 1000 }
    assert_response :success
  end
end
