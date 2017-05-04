require 'test_helper'

class FrontendFlowTest < ActionDispatch::IntegrationTest
  def setup
    Rails.cache.clear
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
    get '/api/v1/vocabulary',
        params: { page: 1, per_page: per_page },
        headers: { token: @user.token }
    data = JSON.parse response.body
    voc = data['card_ids']
    assert_equal(per_page, voc.count)
    # Make sure we already have the cards referenced
    voc.each do |card_id|
      assert_not_nil(1, cards[card_id])
    end

    post "/api/v1/assessments/#{voc.first}",
         headers: { token: @user.token },
         params: { rating: 5 }
    assert_response :success
  end
end
