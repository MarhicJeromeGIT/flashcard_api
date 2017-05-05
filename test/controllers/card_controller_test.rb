require 'test_helper'

class CardControllerTest < ActionDispatch::IntegrationTest
  def setup
    Rails.cache.clear
    clear_redis
    FactoryGirl.create_list(:card, 30)
    @user = create(:user)
  end

  test 'the card list is correctly generated and cached' do
    get '/api/v1/cards'
    assert_response :success
    cards = JSON.parse response.body

    get '/api/v1/cards'
    assert_response :success
    cards_cached = JSON.parse response.body

    assert_equal(cards, cards_cached)
  end

  test 'the vocabulary list (cards to study next) is correctly updated' do
    get '/api/v1/study_schedule', headers: { token: @user.token }
    assert_response :success
    data = JSON.parse response.body
    vocabulary = data['deck']

    assert_equal(Card.count, vocabulary.count)
    first_card_id = vocabulary[0][0]

    # Assess the first card, and make sure that now it's
    # at the back of the 'to study' list
    post "/api/v1/assessments/#{first_card_id}",
         headers: { token: @user.token },
         params: { rating: 5, elapsed_time: 1000 }

    get '/api/v1/study_schedule', headers: { token: @user.token }
    assert_response :success
    data = JSON.parse response.body
    vocabulary = data['deck']
    assert_equal(Card.count, vocabulary.count)
    assert_equal(first_card_id, vocabulary.last[0])

    # Test pagination
    get '/api/v1/study_schedule',
        headers: { token: @user.token },
        params: { page: 1, per_page: 4 }
    assert_response :success
    data = JSON.parse response.body
    paged_voc = data['deck']
    assert_equal(paged_voc, vocabulary[0..3])
  end
end
