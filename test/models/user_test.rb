require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    clear_redis
  end

  test 'new user have a deck' do
    FactoryGirl.create_list(:card, 30)
    user = create(:user)
    assert_not_empty(user.deck)
    assert_not_empty(user.todays_session)
  end

  test 'successful cards are not repeated in todays session' do
    FactoryGirl.create_list(:card, 3)
    user = create(:user)

    todays_session = user.todays_session
    first_card_id, second_card_id, third_card_id = todays_session
    user.assess(card_id: first_card_id, rating: 4, elapsed_time: 1000)
    user.assess(card_id: second_card_id, rating: 5, elapsed_time: 1000)

    todays_session = user.todays_session
    assert_not_includes(todays_session, first_card_id)
    assert_not_includes(todays_session, second_card_id)
    assert_includes(todays_session, third_card_id)
  end

  test 'failed cards are repeated until success in todays sesssion' do
    FactoryGirl.create_list(:card, 1)
    user = create(:user)

    todays_session = user.todays_session
    assert_equal(todays_session.size, 1)
    first_card_id, * = todays_session.size, 1

    4.times do |i|
      user.assess(card_id: first_card_id, rating: i, elapsed_time: 1000)
      todays_session = user.todays_session
      assert_equal(todays_session.size, 1)
    end

    user.assess(card_id: first_card_id, rating: 4, elapsed_time: 1000)
    todays_session = user.todays_session
    assert_equal(todays_session.size, 0)
  end
end
